{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  karchive, kconfig, kcoreaddons, ki18n, qtbase,
}:

mkDerivation {
  name = "kpackage";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ karchive kconfig kcoreaddons ki18n qtbase ];
  patches = [
    ./allow-external-paths.patch
    ./qdiriterator-follow-symlinks.patch
  ];
}
