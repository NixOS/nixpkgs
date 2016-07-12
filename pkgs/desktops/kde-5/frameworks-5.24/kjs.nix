{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
}:

kdeFramework {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  postInstall = ''
    wrapQtProgram "$out/bin/kjs5"
  '';
}
