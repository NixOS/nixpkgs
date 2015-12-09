{ kdeFramework, lib, makeQtWrapper
, extra-cmake-modules
, shared_mime_info
}:

kdeFramework {
  name = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [ shared_mime_info ];
  postInstall = ''
    wrapQtProgram "$out/bin/desktoptojson"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
