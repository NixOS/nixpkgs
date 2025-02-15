{
  stdenv,
  fetchgit,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "xrsh";
  version = "0.142";

  src = fetchgit {
    fetchSubmodules = true;
    url = "https://codeberg.org/xrsh/xrsh.git";
    rev = "12f84e4cf72bf1e1268a6a4120594a825a8f66a7";
    sha256 = "sha256-0MBBlqL2TWgN94ErI2Joub0Aub5XBxGWXILPDAfiNpc=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -r $src/{index.html,src,xrsh.ico,xrsh.svg} $out/.
  '';

  meta = with lib; {
    description = "XR shell which runs a linux ISO in WebXR";
    license = licenses.gpl3Plus;
    homepage = "https://xrsh.isvery.ninja";
    maintainers = with maintainers; [ coderofsalvation ];
    platforms = lib.platforms.all;
  };
}
