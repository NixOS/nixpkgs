{
  mkDerivation, lib,
  extra-cmake-modules,
  kconfig, kwidgetsaddons, qtbase, qttools
}:

mkDerivation {
  name = "kcompletion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kwidgetsaddons qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
