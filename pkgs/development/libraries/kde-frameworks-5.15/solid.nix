{ kdeFramework, lib
, extra-cmake-modules
, makeKDEWrapper
, qtdeclarative
}:

kdeFramework {
  name = "solid";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  buildInputs = [ qtdeclarative ];
  postInstall = ''
    wrapKDEProgram "$out/bin/solid-hardware5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
