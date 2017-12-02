{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, kdoctools,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, ki18n, kiconthemes, kitemviews, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  qtbase, qtscript, qtx11extras, solid,
}:

mkDerivation {
  name = "kio";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kconfigwidgets kdbusaddons ki18n kiconthemes knotifications
    ktextwidgets kwallet kwidgetsaddons kwindowsystem qtscript qtx11extras
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kcoreaddons kitemviews kjobwidgets kservice
    kxmlgui qtbase solid
  ];
  patches =
    [
      ./samba-search-path.patch
      ./kio-debug-module-loader.patch

      # Fix kio-5.40.0 with Qt 5.9.3
      (fetchpatch {
        url = "https://cgit.kde.org/kio.git/patch/?id=2353119aae8f03565bc7779ed1d597d266f5afda";
        sha256 = "19pidf98jm2hx1bga55r4jdjn96xdygasi004s97hpn9bn4nl1hj";
      })
      (fetchpatch {
        url = "https://cgit.kde.org/kio.git/patch/?id=298c0e734efdd8a7b66a531959e3fb5357a6495d";
        sha256 = "1x6m4ivj5001n63z2hmcz0za00l5am2h5a49fs8w051vnmaf13gz";
      })
    ];
}
