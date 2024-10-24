{ lib, stdenv, fetchurl }:

stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-io";
  version = "1.3.2";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${finalAttrs.version}/trunk";
    hash = "sha256-zrfnPWHFoFQkVtxPedKrL1Y1xLZSDX3JuF0qgo/hhnE=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/trunk
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = licenses.unfree;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aaronjheng ];
  };
})
