{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "source-sans";
  version = "3.046";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";
    hash = "sha256-nBLEK+T5n1CdZK2zvCWIhF2MxPmiAwL9l55a55yHtgU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm444 TTF/*.ttf -t $out/share/fonts/truetype
    install -Dm444 VAR/*.otf -t $out/share/fonts/variable

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
