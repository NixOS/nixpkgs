{ kdeFramework, lib, extra-cmake-modules, kdoctools, ki18n, kjs
, makeQtWrapper, qtsvg
}:

kdeFramework {
  name = "kjsembed";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [ ki18n kjs qtsvg ];
  postInstall = ''
    wrapQtProgram "$out/bin/kjscmd5"
    wrapQtProgram "$out/bin/kjsconsole"
  '';
}
