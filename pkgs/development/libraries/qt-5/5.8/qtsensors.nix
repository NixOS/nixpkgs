{ stdenv, qtSubmodule, qtbase, qtdeclarative }:

with stdenv.lib;

qtSubmodule {
  name = "qtsensors";
  qtInputs = [ qtbase qtdeclarative ];
}
