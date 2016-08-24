{ qtSubmodule, qtbase, qtserialport }:

qtSubmodule {
  name = "qtserialbus";
  qtInputs = [ qtbase qtserialport ];
}
