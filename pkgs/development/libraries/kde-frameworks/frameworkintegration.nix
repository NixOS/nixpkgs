{
  mkDerivation,
  extra-cmake-modules,
  kbookmarks,
  kcompletion,
  kconfig,
  kconfigwidgets,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  knotifications,
  kpackage,
  kwidgetsaddons,
  libXcursor,
  qtx11extras,
}:

mkDerivation {
  pname = "frameworkintegration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kbookmarks
    kcompletion
    kconfig
    ki18n
    kio
    knewstuff
    knotifications
    kpackage
    kwidgetsaddons
    libXcursor
    qtx11extras
  ];
  propagatedBuildInputs = [
    kconfigwidgets
    kiconthemes
  ];
}
