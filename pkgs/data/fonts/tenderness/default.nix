{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "601";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tenderness";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-bwJKW+rY7/r2pBCSA6HYlaRMsI/U8UdW2vV4tmYuJww=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${finalAttrs.pname}/";
    description = "Serif font designed by Sora Sagano with old-style figures";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars minijackson ];
    license = licenses.ofl;
  };
})
