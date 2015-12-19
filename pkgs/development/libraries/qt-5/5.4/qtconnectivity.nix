{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
}
