{
  mkDerivation, lib,
  extra-cmake-modules,
  libdmtx, qrencode, qtbase,
}:

mkDerivation {
  name = "prison";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libdmtx qrencode ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
