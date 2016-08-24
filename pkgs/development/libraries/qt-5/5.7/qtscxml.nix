{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtscxml";
  qtInputs = [ qtbase qtdeclarative ];
}
