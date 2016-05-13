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
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    acl karchive kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons ki18n kiconthemes kitemviews kjobwidgets knotifications kservice
    ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui solid qtscript
    qtx11extras
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postInstall = ''
    wrapQtProgram "$out/bin/kcookiejar5"
    wrapQtProgram "$out/bin/ktelnetservice5"
    wrapQtProgram "$out/bin/ktrash5"
    wrapQtProgram "$out/bin/kmailservice5"
    wrapQtProgram "$out/bin/protocoltojson"
  '';
}
