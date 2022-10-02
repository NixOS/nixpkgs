{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kservice, kwindowsystem,
  qtbase, qttools, qtx11extras, libXdmcp,
}:

mkDerivation {
  pname = "kglobalaccel";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kservice kwindowsystem qttools
    qtx11extras libXdmcp
  ];
  outputs = [ "out" "dev" ];
  propagatedBuildInputs = [ qtbase ];
}
