{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation (self: {
  pname = "ferrum";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${self.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-NDJwgFWZgyhMkGRWlY55l2omEw6ju3e3dHCEsWNzQIc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${self.pname}/";
    description = "A decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars minijackson ];
    license = licenses.cc0;
  };
})
