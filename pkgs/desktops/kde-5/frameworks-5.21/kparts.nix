{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kiconthemes, kio, kjobwidgets, knotifications, kservice
, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "kparts";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons kiconthemes kjobwidgets knotifications
    kservice kwidgetsaddons
  ];
  propagatedBuildInputs = [ ki18n kio ktextwidgets kxmlgui ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
