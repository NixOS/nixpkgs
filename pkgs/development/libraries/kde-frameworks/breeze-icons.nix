{ mkDerivation, lib, extra-cmake-modules, qtsvg }:

mkDerivation {
  name = "breeze-icons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  outputs = [ "out" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtsvg ];
  propagatedUserEnvPkgs = [ qtsvg.out ];
}
