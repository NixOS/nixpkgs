{
  mkDerivation, lib,
  extra-cmake-modules,
  bzip2, xz, qtbase, zlib,
}:

mkDerivation {
  name = "karchive";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.14.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ bzip2 xz zlib ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
