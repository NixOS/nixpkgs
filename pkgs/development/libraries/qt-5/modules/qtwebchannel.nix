{ qtModule, qtbase, qtdeclarative }:

qtModule {
  pname = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

