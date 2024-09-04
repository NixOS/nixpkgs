{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "701";
in
stdenvNoCC.mkDerivation {
  pname = "vegur";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/vegur_${majorVersion}${minorVersion}.zip";
    hash = "sha256-sGb3mEb3g15ZiVCxEfAanly8zMUopLOOjw8W4qbXLPA=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/vegur/";
    description = "Humanist sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
    license = licenses.cc0;
  };
}
