{ stdenv, fetchzip }:

let
  version = "2.010";
in fetchzip {
  name = "source-serif-pro-${version}";

  url = "https://github.com/adobe-fonts/source-serif-pro/releases/download/${version}R-ro%2F1.010R-it/source-serif-pro-${version}R-ro-1.010R-it.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,variable}
    unzip -j $downloadedFile "*/OTF/*.otf" -d $out/share/fonts/opentype
    unzip -j $downloadedFile "*/TTF/*.ttf" -d $out/share/fonts/truetype
    unzip -j $downloadedFile "*/VAR/*.otf" -d $out/share/fonts/variable
  '';

  sha256 = "1a3lmqk7hyxpfkb30s9z73lhs823dmq6xr5llp9w23g6bh332x2h";

  meta = with stdenv.lib; {
    homepage = https://adobe-fonts.github.io/source-serif-pro/;
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

