{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kactivities, karchive, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio,
  knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui,
  qtbase, qtdeclarative, qtscript, qtx11extras, kirigami2, qtquickcontrols2
}:

mkDerivation {
  name = "plasma-framework";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kwayland kwindowsystem kxmlgui qtdeclarative qtscript qtx11extras kirigami2
    qtquickcontrols2
  ];
  propagatedBuildInputs = [ kpackage kservice qtbase ];
  # align QtQuick usage with qt5.12, otherwise it will be unable to find certain components
  # see https://github.com/NixOS/nixpkgs/issues/98536
  postPatch = ''
    substituteInPlace src/declarativeimports/plasmaextracomponents/qml/ExpandableListItem.qml \
      --replace "import QtQuick 2.14" "import QtQuick 2.12"
  '';
}
