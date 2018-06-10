{ qtModule, qtbase, qtdeclarative }:

qtModule {
  name = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

