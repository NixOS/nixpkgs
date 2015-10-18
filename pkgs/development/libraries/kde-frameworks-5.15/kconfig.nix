{ kdeFramework, lib
, extra-cmake-modules
, makeQtWrapper
}:

kdeFramework {
  name = "kconfig";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  postInstall = ''
    wrapQtProgram "$out/bin/kreadconfig5"
    wrapQtProgram "$out/bin/kwriteconfig5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
