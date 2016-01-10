{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, acl, karchive
, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons
, kdbusaddons, kdoctools, ki18n, kiconthemes, kitemviews
, kjobwidgets, knotifications, kservice, ktextwidgets, kwallet
, kwidgetsaddons, kwindowsystem, kxmlgui, makeQtWrapper
, qtscript, qtx11extras, solid
}:

kdeFramework {
  name = "kio";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [
    acl karchive kconfig kcoreaddons kdbusaddons kiconthemes
    knotifications ktextwidgets kwallet kwidgetsaddons
    qtscript
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfigwidgets ki18n kitemviews kjobwidgets
    kservice kwindowsystem kxmlgui solid qtx11extras
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kcookiejar5"
    wrapQtProgram "$out/bin/ktelnetservice5"
    wrapQtProgram "$out/bin/ktrash5"
    wrapQtProgram "$out/bin/kmailservice5"
    wrapQtProgram "$out/bin/protocoltojson"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
