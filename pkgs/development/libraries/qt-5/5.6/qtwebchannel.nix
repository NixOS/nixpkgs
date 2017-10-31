{ qtSubmodule, qtbase, qtdeclarative }:

qtSubmodule {
  name = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
}

