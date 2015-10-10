{ kdeFramework, lib, extra-cmake-modules, kbookmarks, kcompletion
, kconfig, kconfigwidgets, ki18n, kiconthemes, kio, knotifications
, kwidgetsaddons, libXcursor, qtx11extras
}:

kdeFramework {
  name = "frameworkintegration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kbookmarks kcompletion kconfig kio knotifications kwidgetsaddons
    libXcursor
  ];
  propagatedBuildInputs = [ kconfigwidgets ki18n kiconthemes qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
