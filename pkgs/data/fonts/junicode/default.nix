{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "junicode";
  version = "2.002";

  src = fetchzip {
    url = "https://github.com/psb1558/Junicode-font/releases/download/v${version}/Junicode_${version}.zip";
    hash = "sha256-AHy4uT0LEof69+ECoFlKmALPTTPbvRNjmFD240koWAE=";
  };

  outputs = [ "out" "doc" ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/fonts/truetype TTF/*.ttf VAR/*.ttf
    install -Dt $out/share/fonts/opentype OTF/*.otf
    install -Dt $out/share/fonts/woff2 WOFF2/*.woff2

    install -Dt $doc/share/doc/${pname}-${version} docs/*.pdf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
