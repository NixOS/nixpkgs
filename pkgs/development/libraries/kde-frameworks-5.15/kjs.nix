{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
, makeKDEWrapper
}:

kdeFramework {
  name = "kjs";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kjs5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
