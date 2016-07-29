{ kdeFramework, lib, extra-cmake-modules, kbookmarks, kcompletion
, kconfig, kconfigwidgets, ki18n, kiconthemes, kio, knotifications
, kwidgetsaddons, libXcursor, qtx11extras
}:

kdeFramework {
  name = "frameworkintegration";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kconfigwidgets knotifications ki18n kio
    kiconthemes kwidgetsaddons libXcursor qtx11extras
  ];
}
