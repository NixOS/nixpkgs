{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kreadconfig5"
    wrapKDEProgram "$out/bin/kwriteconfig5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
