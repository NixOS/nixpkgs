{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtdoc";
  propagatedBuildInputs = [ qtdeclarative ];
  outputs = [ "out" ];
}
