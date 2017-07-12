{ qtSubmodule, qtdeclarative }:

qtSubmodule {
  name = "qtdoc";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" ];
}
