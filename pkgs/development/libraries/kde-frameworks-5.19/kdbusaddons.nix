{ kdeFramework, lib
, extra-cmake-modules
, makeQtWrapper
, qtx11extras
}:

kdeFramework {
  name = "kdbusaddons";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [ qtx11extras ];
  postInstall = ''
    wrapQtProgram "$out/bin/kquitapp5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
