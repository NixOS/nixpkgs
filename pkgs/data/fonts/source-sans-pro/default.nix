{ stdenv, fetchzip }:

fetchzip {
  name = "source-sans-pro-2.040";

  url = "https://github.com/adobe-fonts/source-sans-pro/releases/download/2.040R-ro%2F1.090R-it/source-sans-pro-2.040R-ro-1.090R-it.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype $out/share/fonts/variable
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "1n7z9xpxls74xxjsa61df1ln86y063m07w1f4sbxpjaa0frim4pp";

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
