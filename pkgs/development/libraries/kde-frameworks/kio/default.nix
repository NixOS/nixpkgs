{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, kdoctools, qttools,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, ki18n, kiconthemes, kitemviews, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  qtbase, qtscript, qtx11extras, solid, kcrash
}:

mkDerivation {
  name = "kio";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kconfigwidgets kdbusaddons ki18n kiconthemes knotifications
    ktextwidgets kwallet kwidgetsaddons kwindowsystem qtscript qtx11extras
    kcrash
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kcoreaddons kitemviews kjobwidgets kservice
    kxmlgui qtbase qttools solid
  ];
  outputs = [ "out" "dev" ];
  patches = [
    ./samba-search-path.patch
    ./kio-debug-module-loader.patch
    # https://mail.kde.org/pipermail/distributions/2021-February/000938.html
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kio/commit/a183dd0d1ee0659e5341c7cb4117df27edd6f125.patch";
      sha256 = "1msnzi93zggxgarx962gnlz1slx13nc3l54wib3rdlj0xnnlfdnd";
    })
  ];
}
