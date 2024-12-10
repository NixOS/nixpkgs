{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eunomia";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-Rd2EakaTWjzoEV00tHTgg/bXgJUFfPjCyQUWi7QhFG4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/eunomia/";
    description = "A futuristic decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      leenaars
      minijackson
    ];
    license = licenses.ofl;
  };
})
