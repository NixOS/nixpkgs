{ qtModule, qtdeclarative }:

qtModule {
  name = "qtdoc";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" ];
}
