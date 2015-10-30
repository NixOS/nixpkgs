{ kdeFramework, lib
, extra-cmake-modules
, kbookmarks
, kcompletion
, kconfig
, kconfigwidgets
, ki18n
, kiconthemes
, kio
, knotifications
, kwidgetsaddons
, libXcursor
, qtx11extras
}:

kdeFramework {
  name = "frameworkintegration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kbookmarks
    kcompletion
    kconfig
    ki18n
    kio
    knotifications
    kwidgetsaddons
    libXcursor
    qtx11extras
  ];
  propagatedBuildInputs = [ kconfigwidgets kiconthemes ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
