{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
}:

kdeFramework {
  name = "kjs";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kjs5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
