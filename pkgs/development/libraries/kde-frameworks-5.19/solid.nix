{ kdeFramework, lib
, extra-cmake-modules
, makeQtWrapper
, qtdeclarative
}:

kdeFramework {
  name = "solid";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [ qtdeclarative ];
  postInstall = ''
    wrapQtProgram "$out/bin/solid-hardware5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
