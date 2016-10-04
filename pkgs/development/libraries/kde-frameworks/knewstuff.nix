{ kdeFramework, lib, ecm, attica, karchive
, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes, kio
, kitemviews, kservice, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "knewstuff";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    attica karchive kcompletion kconfig kcoreaddons ki18n kiconthemes kio
    kitemviews kservice ktextwidgets kwidgetsaddons kxmlgui
  ];
}
