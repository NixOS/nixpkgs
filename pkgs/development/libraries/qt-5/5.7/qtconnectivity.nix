{ qtSubmodule, qtbase, qtdeclarative, bluez, stdenv, pkgconfig }:

qtSubmodule {
  name = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = with stdenv; lib.optional isLinux [ bluez pkgconfig ];
}
