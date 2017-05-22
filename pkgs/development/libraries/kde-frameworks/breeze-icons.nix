{ mkDerivation, lib, extra-cmake-modules, qtsvg }:

mkDerivation {
  name = "breeze-icons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtsvg ];
  outputs = [ "out" ]; # only runtime outputs
}
