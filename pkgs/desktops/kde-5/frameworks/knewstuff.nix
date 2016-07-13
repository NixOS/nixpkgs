{ kdeFramework, lib, extra-cmake-modules, attica, karchive
, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes, kio
, kitemviews, kservice, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "knewstuff";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    attica karchive kcompletion kconfig kcoreaddons ki18n kiconthemes kio
    kitemviews kservice ktextwidgets kwidgetsaddons kxmlgui
  ];
}
