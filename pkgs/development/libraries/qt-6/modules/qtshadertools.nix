{ lib
, stdenv
, qtModule
, qtbase
}:

qtModule {
  pname = "qtshadertools";
  buildInputs = [ qtbase ];
}
