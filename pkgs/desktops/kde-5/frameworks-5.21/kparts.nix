{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kiconthemes, kio, kjobwidgets, knotifications, kservice
, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "kparts";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kiconthemes kio kjobwidgets knotifications
    kservice ktextwidgets kwidgetsaddons kxmlgui
  ];
}
