{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kactivities, karchive, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio,
  knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui,
  qtbase, qtdeclarative, qtscript, qtx11extras, kirigami2, qtquickcontrols2
}:

mkDerivation {
  pname = "plasma-framework";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kwayland kwindowsystem kxmlgui qtdeclarative qtscript qtx11extras
    qtquickcontrols2
  ];
  propagatedBuildInputs = [ kpackage kservice qtbase kirigami2 ];
}
