{ lib, fetchzip }:

let
  version = "1.002";
in fetchzip rec {
  name = "anonymousPro-${version}";

  url = "http://www.marksimonson.com/assets/content/fonts/AnonymousPro-${version}.zip";
  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf                           -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt                           -d "$out/share/doc/${name}"
  '';
  sha256 = "05rgzag38qc77b31sm5i2vwwrxbrvwzfsqh3slv11skx36pz337f";

  meta = with lib; {
    homepage = https://www.marksimonson.com/fonts/view/anonymous-pro;
    description = "TrueType font set intended for source code";
    longDescription = ''
      Anonymous Pro (2009) is a family of four fixed-width fonts
      designed with coding in mind. Anonymous Pro features an
      international, Unicode-based character set, with support for
      most Western and Central European Latin-based languages, plus
      Greek and Cyrillic. It is designed by Mark Simonson.
    '';
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
