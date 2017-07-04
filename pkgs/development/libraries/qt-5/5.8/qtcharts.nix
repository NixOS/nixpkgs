{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtcharts";
  qtInputs = [ qtbase ];
}
