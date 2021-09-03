{ qtModule, qtbase, qtserialport }:

qtModule {
  pname = "qtserialbus";
  qtInputs = [ qtbase qtserialport ];
}
