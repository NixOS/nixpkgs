{ kdeFramework, lib, ecm, kconfig, kcoreaddons
, ki18n, kiconthemes, kio, kjobwidgets, knotifications, kservice
, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "kparts";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kiconthemes kio kjobwidgets knotifications
    kservice ktextwidgets kwidgetsaddons kxmlgui
  ];
}
