{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qttools";
  qtInputs = [ qtbase ];
}
