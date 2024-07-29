{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "public-sans";
  version = "2.001";

  src = fetchzip {
    url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";
    stripRoot = false;
    hash = "sha256-XFs/UMXI/kdrW+53t8Mj26+Rn5p+LQ6KW2K2/ShoIag=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*/*.otf -t $out/share/fonts/opentype
    install -Dm644 */*/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Strong, neutral, principles-driven, open source typeface for text or display";
    homepage = "https://public-sans.digital.gov/";
    changelog = "https://github.com/uswds/public-sans/raw/v${version}/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
