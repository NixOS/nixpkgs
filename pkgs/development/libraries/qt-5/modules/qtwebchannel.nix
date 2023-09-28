{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}
