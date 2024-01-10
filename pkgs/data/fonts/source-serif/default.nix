{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "source-serif";
  version = "4.005";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-serif/archive/refs/tags/${version}R.zip";
    hash = "sha256-djeRJWcKqirkHus52JSeZJXeB7yMTnUXpkPxyzgRC04=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm444 TTF/*.ttf -t $out/share/fonts/truetype
    install -Dm444 VAR/*.otf -t $out/share/fonts/variable

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-serif/";
    description = "Typeface for setting text in many sizes, weights, and languages. Designed to complement Source Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
