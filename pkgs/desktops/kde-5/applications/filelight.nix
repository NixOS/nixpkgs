{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, qtscript
, kio
, solid
, kxmlgui
, kparts
}:

kdeApp {
  name = "filelight";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kio kparts qtscript solid kxmlgui
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/filelight"
  '';
}
