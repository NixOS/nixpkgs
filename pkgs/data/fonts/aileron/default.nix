{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "102";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aileron";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-Ht48gwJZrn0djo1yl6jHZ4+0b710FVwStiC1Zk5YXME=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${finalAttrs.pname}/";
    description = "A helvetica font in nine weights";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars minijackson ];
    license = licenses.cc0;
  };
})
