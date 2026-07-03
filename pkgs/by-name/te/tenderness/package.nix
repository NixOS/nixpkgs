{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "601";
in
stdenvNoCC.mkDerivation {
  pname = "tenderness";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/tenderness_${majorVersion}${minorVersion}.zip";
    hash = "sha256-bwJKW+rY7/r2pBCSA6HYlaRMsI/U8UdW2vV4tmYuJww=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://dotcolon.net/font/tenderness/";
    description = "Serif font designed by Sora Sagano with old-style figures";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.ofl;
  };
}
