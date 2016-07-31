{
  kdeApp, lib, ecm, kdoctools, makeQtWrapper,
  kparts, ktexteditor, kwidgetsaddons, libkomparediff2
}:

kdeApp {
  name = "kompare";
  meta = {
    license = with lib.licenses; [ gpl2 ];
  };

  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];

  propagatedBuildInputs = [ kparts ktexteditor kwidgetsaddons libkomparediff2 ];

  postInstall = ''
    wrapQtProgram "$out/bin/kompare"
  '';
}
