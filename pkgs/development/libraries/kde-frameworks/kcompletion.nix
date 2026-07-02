{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kwidgetsaddons,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kcompletion";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kwidgetsaddons
    qttools
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
