{ kdeFramework, lib, ecm, kcompletion, kconfig
, kconfigwidgets, ki18n, kiconthemes, kservice, kwindowsystem
, sonnet
}:

kdeFramework {
  name = "ktextwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kcompletion kconfig kconfigwidgets ki18n kiconthemes kservice kwindowsystem
    sonnet
  ];
}
