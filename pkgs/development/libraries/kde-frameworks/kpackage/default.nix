{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  karchive, kconfig, kcoreaddons, ki18n, qtbase,
}:

mkDerivation {
  pname = "kpackage";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ karchive kconfig kcoreaddons ki18n qtbase ];
  patches = [
    ./0001-Allow-external-paths-default.patch
    ./0002-QDirIterator-follow-symlinks.patch
  ];
}
