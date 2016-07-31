{
  kdeApp, lib,
  ecm, kdoctools, makeQtWrapper,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kguiaddons,
  ki18n, kiconthemes, kinit, kdelibs4support, kio, knotifications,
  knotifyconfig, kparts, kpty, kservice, ktextwidgets, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript
}:

kdeApp {
  name = "konsole";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kdelibs4support ki18n kwindowsystem qtscript kbookmarks kcompletion kconfig
    kconfigwidgets kcoreaddons kguiaddons kiconthemes kinit kio knotifications
    knotifyconfig kparts kpty kservice ktextwidgets kwidgetsaddons kxmlgui
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/konsole"
  '';
}
