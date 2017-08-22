{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtnetworkauth";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
