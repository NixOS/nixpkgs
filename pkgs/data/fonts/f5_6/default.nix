{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "110";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "f5_6";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-FeCU+mzR0iO5tixI72XUnhvpGj+WRfKyT3mhBtud3uE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${finalAttrs.pname}/";
    description = "Weighted decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars minijackson ];
    license = licenses.ofl;
  };
})
