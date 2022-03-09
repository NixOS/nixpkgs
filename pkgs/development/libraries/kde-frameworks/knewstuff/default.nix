{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  attica, karchive, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes,
  kio, kitemviews, kpackage, kservice, ktextwidgets, kwidgetsaddons, kxmlgui, qtbase,
  qtdeclarative, kirigami2, syndication,
}:

mkDerivation {
  name = "knewstuff";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kcompletion kconfig kcoreaddons ki18n kiconthemes kio kitemviews
    kpackage
    ktextwidgets kwidgetsaddons qtbase qtdeclarative kirigami2 syndication
  ];
  propagatedBuildInputs = [ attica kservice kxmlgui ];
  patches = [
    ./0001-Delay-resolving-knsrcdir.patch
    # The following two patches mitigate a cache expiration bug. Upstream
    # requested we backport these patches to reduce load on KDE infrastructure:
    # https://mail.kde.org/pipermail/distributions/2022-February/001140.html
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/knewstuff/-/commit/c8165b7a0d622e318b3353ccf257a8f229dd12c9.patch";
      sha256 = "1b6cbxzfqnnym6gkb8vkhgffibyk560bfcvx0znsnlx03ahavdmf";
    })
    ./knewstuff-httpworker-cache-expiry.patch
  ];
}
