{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtwebsockets";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}
