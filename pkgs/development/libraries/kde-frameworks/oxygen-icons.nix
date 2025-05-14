{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation {
  pname = "oxygen-icons";
  meta.license = lib.licenses.lgpl3Plus;
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  outputs = [ "out" ]; # only runtime outputs
}
