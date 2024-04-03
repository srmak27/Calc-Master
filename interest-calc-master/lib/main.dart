import 'package:flutter/material.dart';

///Application Entry Point
void main() => runApp(InterestCalcApp());

///Creating Application
class InterestCalcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      title: 'Interest Calculator',
      home: InterestCalcHome(),
    );
  }
}

///Intializing the Stateful Widgets
class InterestCalcHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InterestCalcHomeState();
  }
}

///Crafting the UI
class InterestCalcHomeState extends State<InterestCalcHome> {
  final _formKey = GlobalKey<FormState>();

  final _padding = EdgeInsets.all(12.0);
  final _currencies = ['Taka', 'Dollar', 'Rupees'];
  var selectedItem = '';
  var btnPrimary = Colors.deepPurple;
  var btnSecondary = Colors.redAccent;
  var principalController = TextEditingController();
  var interestController = TextEditingController();
  var periodController = TextEditingController();
  var displayResullt = '';

  @override
  void initState() {
    super.initState();
    selectedItem = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interest Calculator',
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 30.0,
            ),
            getAppIcon(),
            getAmountField(
              'Enter Principals e.g. 1200',
              'Principals',
              Icons.monetization_on,
              principalController,
              _padding,
            ),
            getAmountField(
              'Enter in Percent',
              'Rate of Interest',
              Icons.payment,
              interestController,
              _padding,
            ),
            Padding(
              padding: _padding,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: getAmountField(
                      'Number of Period',
                      'Period',
                      Icons.timer,
                      periodController,
                      EdgeInsets.all(0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: DropdownButton<String>(
                        value: selectedItem,
                        items: _currencies
                            .map(
                              (String dropItems) => DropdownMenuItem<String>(
                                    value: dropItems,
                                    child: Text(dropItems),
                                  ),
                            )
                            .toList(),
                        onChanged: (String selectedItem) =>
                            selectMethod(selectedItem),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: _padding,
              child: Row(
                children: <Widget>[
                  getCalcButton('Calculate', btnPrimary, calculate),
                  Container(
                    width: 10.0,
                  ),
                  getCalcButton('Reset', btnSecondary, reset),
                ],
              ),
            ),
            Padding(
              padding: _padding,
              child: Center(
                child: Text(
                  displayResullt,
                  style: textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creating Application Icon Image
  Widget getAppIcon() {
    AssetImage img = AssetImage('assets/images/bank.png');
    Image appIcon = Image(
      image: img,
      width: 80,
    );
    return Center(
      child: appIcon,
    );
  }

  /// Crafting the TextFormField
  Widget getAmountField(String hintText, String labelText, IconData iconOfField,
      TextEditingController textController, EdgeInsets wrapping) {
    return Container(
      child: Padding(
        padding: wrapping,
        child: TextFormField(
          validator: (String input) {
            if (input.isEmpty) return 'Invalid Input. Please Check';
          },
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Colors.redAccent,
              fontSize: 15.0,
            ),
            prefixIcon: Icon(iconOfField),
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  ///Crafting the Button
  Widget getCalcButton(
      String buttonName, Color buttonColor, Function buttonFunc) {
    return Expanded(
      child: RaisedButton(
        child: Text(
          buttonName,
        ),
        color: buttonColor,
        onPressed: () => setState(
              () {
                if (_formKey.currentState.validate())
                  this.displayResullt = buttonFunc();
              },
            ),
      ),
    );
  }

  /// User Selection Method
  void selectMethod(String selectedItem) {
    setState(() => this.selectedItem = selectedItem);
  }

  /// Button Calculate Method
  String calculate() {
    var principal = double.parse(principalController.text);
    var interest = double.parse(interestController.text);
    var period = double.parse(periodController.text);
    var totalAmmount = principal + (principal * interest * period) / 100;
    var result = 'Total Payable Amount is $totalAmmount $selectedItem.';
    return result;
  }

  ///Button Reset Method
  String reset() {
    principalController.text = '';
    interestController.text = '';
    periodController.text = '';
    displayResullt = '';
    selectedItem = _currencies[0];
    return '';
  }
}
