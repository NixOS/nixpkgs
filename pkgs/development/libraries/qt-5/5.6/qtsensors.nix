{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
}
