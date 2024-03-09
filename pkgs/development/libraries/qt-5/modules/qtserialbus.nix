{ qtModule, qtbase, qtserialport }:

qtModule {
  pname = "qtserialbus";
  propagatedBuildInputs = [ qtbase qtserialport ];
}
