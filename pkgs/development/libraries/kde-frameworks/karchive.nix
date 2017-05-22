{
  mkDerivation, lib,
  extra-cmake-modules,
  bzip2, lzma, qtbase, zlib,
}:

mkDerivation {
  name = "karchive";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ bzip2 lzma zlib ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
