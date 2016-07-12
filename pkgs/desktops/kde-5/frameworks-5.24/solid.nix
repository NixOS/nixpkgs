{ kdeFramework, lib
, extra-cmake-modules
, makeQtWrapper
, qtdeclarative
}:

kdeFramework {
  name = "solid";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [ qtdeclarative ];
  postInstall = ''
    wrapQtProgram "$out/bin/solid-hardware5"
  '';
}
