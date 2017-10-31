{ stdenv, fetchzip }:

let
  date = "2016-05-13";
in fetchzip {
  name = "siji-${date}";

  url = https://github.com/stark/siji/archive/95369afac3e661cb6d3329ade5219992c88688c1.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.pcf -d $out/share/fonts/pcf
  '';

  sha256 = "1799hs7zd8w7qyja4mii9ggmrm786az7ldsqwx9mbi51b56ym640";

  meta = {
    homepage = https://github.com/stark/siji;
    description = "An iconic bitmap font based on Stlarch with additional glyphs";
    liscense = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.asymmetric ];
  };
}
