{ kdeFramework, lib, extra-cmake-modules, kdoctools, ki18n, kjs
, makeQtWrapper, qtsvg
}:

kdeFramework {
  name = "kjsembed";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [ qtsvg ];
  propagatedBuildInputs = [ ki18n kjs ];
  postInstall = ''
    wrapQtProgram "$out/bin/kjscmd5"
    wrapQtProgram "$out/bin/kjsconsole"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
