{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "smiley-sans";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/atelier-anchor/smiley-sans/releases/download/v${version}/smiley-sans-v${version}.zip";
    sha256 = "sha256-gpPJuf1Eye5rP6tpaGJEUFnk2Ys0GhSNRUT5HQE2P8E=";
  };

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    install -Dm644 -t $out/share/fonts/opentype *.otf
    install -Dm644 -t $out/share/fonts/truetype *.ttf
    install -Dm644 -t $out/share/fonts *.woff2
    runHook postInstall
  '';

  meta = with lib; {
    description = "A condensed and oblique Chinese typeface seeking a visual balance between the humanist and the geometric";
    homepage = "https://atelier-anchor.com/typefaces/smiley-sans/";
    changelog = "https://github.com/atelier-anchor/smiley-sans/blob/main/CHANGELOG.md";
    license = licenses.ofl;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = platforms.all;
  };
}
