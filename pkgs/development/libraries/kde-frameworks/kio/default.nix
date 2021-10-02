{
  mkDerivation, fetchpatch,
  util-linux, extra-cmake-modules, kdoctools, qttools,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, ki18n, kiconthemes, kitemviews, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  qtbase, qtscript, qtx11extras, solid, kcrash
}:

mkDerivation {
  name = "kio";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    util-linux karchive kconfigwidgets kdbusaddons ki18n kiconthemes knotifications
    ktextwidgets kwallet kwidgetsaddons kwindowsystem qtscript qtx11extras
    kcrash
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kcoreaddons kitemviews kjobwidgets kservice
    kxmlgui qtbase qttools solid
  ];
  outputs = [ "out" "dev" ];
  patches = [
    ./0001-Remove-impure-smbd-search-path.patch
    ./0002-Debug-module-loader.patch
 ];
}
