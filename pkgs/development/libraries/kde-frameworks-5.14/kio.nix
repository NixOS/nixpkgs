{ kdeFramework, lib, extra-cmake-modules, acl, karchive
, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons
, kdbusaddons, kdoctools, ki18n, kiconthemes, kitemviews
, kjobwidgets, knotifications, kservice, ktextwidgets, kwallet
, kwidgetsaddons, kwindowsystem, kxmlgui, qtscript, qtx11extras
, solid
}:

kdeFramework {
  name = "kio";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    acl karchive kconfig kcoreaddons kdbusaddons kiconthemes
    knotifications ktextwidgets kwallet kwidgetsaddons kwindowsystem
    qtscript
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfigwidgets ki18n kitemviews kjobwidgets
    kservice kxmlgui solid qtx11extras
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
