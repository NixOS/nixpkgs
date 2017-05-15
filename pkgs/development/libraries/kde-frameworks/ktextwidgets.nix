{ mkDerivation, lib, extra-cmake-modules, kcompletion, kconfig
, kconfigwidgets, ki18n, kiconthemes, kservice, kwindowsystem
, sonnet
}:

mkDerivation {
  name = "ktextwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets ki18n kiconthemes kservice kwindowsystem
    sonnet
  ];
}
