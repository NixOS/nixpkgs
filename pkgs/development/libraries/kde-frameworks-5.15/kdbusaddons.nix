{ kdeFramework, lib
, extra-cmake-modules
, makeKDEWrapper
, qtx11extras
}:

kdeFramework {
  name = "kdbusaddons";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  propagatedBuildInputs = [ qtx11extras ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kquitapp5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
