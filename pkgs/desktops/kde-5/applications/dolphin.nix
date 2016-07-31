{
  kdeApp, lib,
  ecm, kdoctools, makeQtWrapper,
  baloo, baloo-widgets, kactivities, kbookmarks, kcmutils, kcompletion, kconfig,
  kcoreaddons, kdelibs4support, kdbusaddons, kfilemetadata, ki18n, kiconthemes,
  kinit, kio, knewstuff, knotifications, kparts, ktexteditor, kwindowsystem,
  phonon, solid
}:

kdeApp {
  name = "dolphin";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    baloo baloo-widgets kactivities kbookmarks kcmutils kcompletion kconfig
    kcoreaddons kdelibs4support kdbusaddons kfilemetadata ki18n kiconthemes
    kinit kio knewstuff knotifications kparts ktexteditor kwindowsystem phonon
    solid
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/dolphin"
  '';
}
