{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtx11extras";
  qtInputs = [ qtbase ];
}
