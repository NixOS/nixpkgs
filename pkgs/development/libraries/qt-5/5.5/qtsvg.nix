{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtsvg";
  qtInputs = [ qtbase ];
}
