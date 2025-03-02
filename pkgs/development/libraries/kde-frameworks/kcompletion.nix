{
  mkDerivation,
  extra-cmake-modules,
  kconfig,
  kwidgetsaddons,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kcompletion";
  nativeBuildInputs = [ extra-cmake-modules ];
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
