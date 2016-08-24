{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtmacextras";
  qtInputs = [ qtbase ];
}
