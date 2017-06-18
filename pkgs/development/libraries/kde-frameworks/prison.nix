{
  mkDerivation, lib,
  extra-cmake-modules,
  libdmtx, qrencode, qtbase,
}:

mkDerivation {
  name = "prison";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libdmtx qrencode ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
