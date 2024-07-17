{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "701";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vegur";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
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
    description = "A humanist sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
      samueldr
    ];
    license = licenses.cc0;
  };
})
