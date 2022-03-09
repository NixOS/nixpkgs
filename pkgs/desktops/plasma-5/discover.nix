{ mkDerivation
, lib
, fetchpatch
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
  pname = "discover";
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
  patches = [
    # The following patch mitigates a cache expiration bug. Upstream requested
    # we backport this patch to reduce load on KDE infrastructure:
    # https://mail.kde.org/pipermail/distributions/2022-February/001140.html
    (fetchpatch {
      url = "https://invent.kde.org/plasma/discover/-/commit/6257e21c313e21afd80d101d24c78d66621236b1.patch";
      sha256 = "1sss2wk0qnyk4cv475k1fjkkcd6nskz3hfy5y9nnrxpnw51xai38";
    })
  ];
}
