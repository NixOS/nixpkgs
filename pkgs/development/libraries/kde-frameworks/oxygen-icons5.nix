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
  outputs = [ "out" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
