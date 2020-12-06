{ mkDerivation
, lib
, extra-cmake-modules, qtbase
}:

mkDerivation {
  name = "oxygen-icons5";
  meta = {
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" ]; # only runtime outputs
}
