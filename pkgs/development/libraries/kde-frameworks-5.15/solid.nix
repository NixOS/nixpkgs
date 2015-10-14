{ kdeFramework, lib
, extra-cmake-modules
, makeKDEWrapper
}:

kdeFramework {
  name = "solid";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  postInstall = ''
    wrapKDEProgram "$out/bin/solid-hardware5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
