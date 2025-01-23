{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-io";
  version = "1.3.4";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${finalAttrs.version}/trunk";
    hash = "sha256-ifvdjHtjZJ7rFHlBV1e4mJA8BB5ztJt4Ao29ZOyjCHo=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/trunk
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
})
