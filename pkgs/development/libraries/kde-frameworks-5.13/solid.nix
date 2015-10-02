{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "solid";
  nativeBuildInputs = [ extra-cmake-modules ];
  postInstall = ''
    wrapKDEProgram "$out/bin/solid-hardware5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
