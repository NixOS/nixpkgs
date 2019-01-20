{ stdenv, fetchzip }:

fetchzip {
  name = "source-sans-pro-2.045";

  url = https://github.com/adobe-fonts/source-sans-pro/releases/download/2.045R-ro%2F1.095R-it/source-sans-pro-2.045R-ro-1.095R-it.zip;

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "0xjdp226ybdcfylbpfsdgnz2bf4pj4qv1wfs6fv22hjxlzqfixf3";

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
