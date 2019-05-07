{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  appstream-qt, discount, flatpak, fwupd, ostree, packagekit-qt, pcre, utillinux,
  qtquickcontrols2,
  karchive, kconfig, kcrash, kdbusaddons, kdeclarative, kio, kirigami2, kitemmodels,
  knewstuff, kwindowsystem, kxmlgui, plasma-framework
}:

mkDerivation {
  name = "discover";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    # discount is needed for libmarkdown
    appstream-qt discount flatpak fwupd ostree packagekit-qt pcre utillinux
    qtquickcontrols2
    karchive kconfig kcrash kdbusaddons kdeclarative kio kirigami2 kitemmodels knewstuff kwindowsystem kxmlgui
    plasma-framework
  ];
}
