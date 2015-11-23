{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
}:

kdeFramework {
  name = "kjs";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  postInstall = ''
    wrapQtProgram "$out/bin/kjs5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
