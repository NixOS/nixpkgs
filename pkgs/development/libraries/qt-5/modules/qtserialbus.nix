{ qtModule, qtbase, qtserialport }:

qtModule {
  name = "qtserialbus";
  qtInputs = [ qtbase qtserialport ];
}
