{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "1";
  minorVersion = "101";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "f1_8";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://note.com/api/v2/attachments/download/d83b2c4ec63d7826acaa76725d261ff4";
    hash = "sha256-pe1G8WeFAo+KYjjsNwn0JmtXFn9QugE1SeGwaqnl1F0=";
    stripRoot = false;
    extension = "zip";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${finalAttrs.pname}/";
    description = "A weighted decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
    license = licenses.ofl;
  };
})
