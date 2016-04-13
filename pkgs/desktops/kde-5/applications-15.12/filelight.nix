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
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    kio
    kparts
    qtscript
    solid
    kxmlgui
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/filelight"
  '';
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
  };
}
