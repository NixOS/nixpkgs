{
  kdeApp, lib,
  ecm, kdoctools, makeQtWrapper,
  kio, kparts, kxmlgui, qtscript, solid
}:

kdeApp {
  name = "filelight";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh vcunat ];
  };
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kio kparts kxmlgui qtscript solid
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/filelight"
  '';
}
