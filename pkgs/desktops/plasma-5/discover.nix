{ mkDerivation
, lib
, extra-cmake-modules
, gettext
, kdoctools
, python3
, appstream-qt
, discount
, flatpak
, fwupd
, ostree
, packagekit-qt
, pcre
, util-linux
, qtbase
, qtquickcontrols2
, qtx11extras
, karchive
, kcmutils
, kconfig
, kcrash
, kdbusaddons
, kdeclarative
, kidletime
, kio
, kirigami2
, kitemmodels
, knewstuff
, kwindowsystem
, kxmlgui
, plasma-framework
}:

mkDerivation {
  name = "discover";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python3 ];
  buildInputs = [
    # discount is needed for libmarkdown
    appstream-qt
    discount
    flatpak
    fwupd
    ostree
    packagekit-qt
    pcre
    util-linux
    qtquickcontrols2
    qtx11extras
    karchive
    kcmutils
    kconfig
    kcrash
    kdbusaddons
    kdeclarative
    kidletime
    kio
    kirigami2
    kitemmodels
    knewstuff
    kwindowsystem
    kxmlgui
    plasma-framework
  ];
}
