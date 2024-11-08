{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "source-code-pro";
  version = "2.042";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-code-pro/releases/download/${version}R-u%2F1.062R-i%2F1.026R-vf/OTF-source-code-pro-${version}R-u_1.062R-i.zip";
    stripRoot = false;
    hash = "sha256-+BnfmD+AjObSoVxPvFAqbnMD2j5qf2YmbXGQtXoaiy0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 OTF/*.otf -t $out/share/fonts/opentype

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
