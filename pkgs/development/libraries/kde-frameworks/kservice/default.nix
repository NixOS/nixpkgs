{
  mkDerivation,
  bison, extra-cmake-modules, flex,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kdoctools, ki18n, kwindowsystem,
  qtbase, shared-mime-info,
}:

mkDerivation {
  pname = "kservice";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedNativeBuildInputs = [ bison flex ];
  buildInputs = [
    kcrash kdbusaddons ki18n kwindowsystem qtbase
  ];
  propagatedBuildInputs = [ kconfig kcoreaddons ];
  propagatedUserEnvPkgs = [ shared-mime-info ]; # for kbuildsycoca5
  patches = [
    ./qdiriterator-follow-symlinks.patch
    ./no-canonicalize-path.patch
  ];
}
