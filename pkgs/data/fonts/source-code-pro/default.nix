{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "source-code-pro";
  version = "2.038";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-code-pro/releases/download/${version}R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-${version}R-ro-1.058R-it.zip";
    stripRoot = false;
    hash = "sha256-ijeTLka131jf6B9xj/eNWK1T5r7r3aBXBgnVyRAxmuY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Monospaced font family for user interface and coding environments";
    maintainers = with lib.maintainers; [ relrod ];
    platforms = with lib.platforms; all;
    homepage = "https://adobe-fonts.github.io/source-code-pro/";
    license = lib.licenses.ofl;
  };
}
