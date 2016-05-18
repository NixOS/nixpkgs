{ kdeFramework, lib, extra-cmake-modules, kcompletion, kconfig
, kconfigwidgets, ki18n, kiconthemes, kservice, kwindowsystem
, sonnet
}:

kdeFramework {
  name = "ktextwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets ki18n kiconthemes kservice kwindowsystem
    sonnet
  ];
}
