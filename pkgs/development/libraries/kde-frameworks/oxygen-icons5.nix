{ mkDerivation
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation {
  name = "oxygen-icons5";
  meta.license = lib.licenses.lgpl3Plus;
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" ]; # only runtime outputs
}
