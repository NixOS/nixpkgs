{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtimageformats";
  qtInputs = [ qtbase ];
}
