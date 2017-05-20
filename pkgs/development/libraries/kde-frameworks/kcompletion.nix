{ kdeFramework, lib, extra-cmake-modules, kconfig, kwidgetsaddons, qtbase, qttools }:

kdeFramework {
  name = "kcompletion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ kconfig kwidgetsaddons ];
}
