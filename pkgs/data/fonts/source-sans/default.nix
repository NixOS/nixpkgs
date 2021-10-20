{ lib, fetchzip }:

let
  version = "3.046";
in fetchzip {
  name = "source-sans-${version}";

  url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "1wxdinnliq0xqbjrs0sqykwaggkmyqawfq862d9xn05g1pnxda94";

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
