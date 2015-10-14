{ kdeFramework, lib
, extra-cmake-modules
, makeKDEWrapper
}:

kdeFramework {
  name = "kconfig";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kreadconfig5"
    wrapKDEProgram "$out/bin/kwriteconfig5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
