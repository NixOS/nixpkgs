{
  mkDerivation, lib,
  extra-cmake-modules,
  kcompletion, kconfig, kconfigwidgets, ki18n, kiconthemes, kservice,
  kwindowsystem, qtbase, sonnet,
}:

mkDerivation {
  name = "ktextwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kiconthemes kservice kwindowsystem
  ];
  propagatedBuildInputs = [ ki18n qtbase sonnet ];
}
