{ lib, stdenvNoCC, fetchzip }:

# Source Serif Pro got renamed to Source Serif 4 (see
# https://github.com/adobe-fonts/source-serif/issues/77). This is the
# last version named "Pro". It is useful for backward compatibility
# with older documents/templates/etc.

stdenvNoCC.mkDerivation rec {
  pname = "source-serif-pro";
  version = "3.001";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-serif/releases/download/${version}R/source-serif-pro-${version}R.zip";
    hash = "sha256-chXoaPOACtQ7wz/etElXuIJH/yvUsP03WlxeCfqWF/w=";
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
