{
  mkDerivation, fetchpatch,
  extra-cmake-modules, gettext, kdoctools, python,
  appstream-qt, discount, flatpak, fwupd, ostree, packagekit-qt, pcre, utillinux,
  qtquickcontrols2,
  karchive, kconfig, kcrash, kdbusaddons, kdeclarative, kio, kirigami2, kitemmodels,
  knewstuff, kwindowsystem, kxmlgui, plasma-framework
}:

mkDerivation {
  name = "discover";
  patches = [
    (fetchpatch {
      name = "CVE-2021-28117.patch";
      url = "https://invent.kde.org/plasma/discover/-/commit/94478827aab63d2e2321f0ca9ec5553718798e60.patch";
      sha256 = "1r7lb5vm75xk2np2fjlcddf8pwcm76iabk8bxznn6p0nif11xjal";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    # discount is needed for libmarkdown
    appstream-qt discount flatpak fwupd ostree packagekit-qt pcre utillinux
    qtquickcontrols2
    karchive kconfig kcrash kdbusaddons kdeclarative kio kirigami2 kitemmodels knewstuff kwindowsystem kxmlgui
    plasma-framework
  ];
}
