{ lib, fetchzip }:

let
  version = "3.000";
in fetchzip {
  name = "source-serif-pro-${version}";

  url = "https://github.com/adobe-fonts/source-serif-pro/releases/download/${version}R/source-serif-pro-${version}R.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "06yp8y79mqk02qzp81h8zkmzqqlhicgrkwmzkd0bm338xh8grsiz";

  meta = with lib; {
    homepage = https://adobe-fonts.github.io/source-serif-pro/;
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

