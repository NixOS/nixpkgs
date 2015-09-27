{ mkDerivation, lib
, extra-cmake-modules
, acl
, karchive
, kbookmarks
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdoctools
, ki18n
, kiconthemes
, kitemviews
, kjobwidgets
, knotifications
, kservice
, ktextwidgets
, kwallet
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, qtscript
, qtx11extras
, solid
}:

mkDerivation {
  name = "kio";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    acl karchive kconfig kcoreaddons kdbusaddons ki18n kiconthemes
    knotifications ktextwidgets kwallet kwidgetsaddons kwindowsystem
    qtscript qtx11extras
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfigwidgets kitemviews kjobwidgets kservice kxmlgui solid
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kcookiejar5"
    wrapKDEProgram "$out/bin/ktelnetservice5"
    wrapKDEProgram "$out/bin/ktrash5"
    wrapKDEProgram "$out/bin/kmailservice5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
