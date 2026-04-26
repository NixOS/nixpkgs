{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kservice,
  kwindowsystem,
  qtbase,
  qttools,
  qtx11extras,
  libxdmcp,
}:

mkDerivation {
  pname = "kglobalaccel";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kservice
    kwindowsystem
    qttools
    qtx11extras
    libxdmcp
  ];
  outputs = [
    "out"
    "dev"
  ];
  propagatedBuildInputs = [ qtbase ];
}
