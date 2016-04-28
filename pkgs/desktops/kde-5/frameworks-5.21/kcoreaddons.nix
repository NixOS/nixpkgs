{ kdeFramework, lib, makeQtWrapper
, extra-cmake-modules
, shared_mime_info
}:

kdeFramework {
  name = "kcoreaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [ shared_mime_info ];
  postInstall = ''
    wrapQtProgram "$out/bin/desktoptojson"
  '';
}
