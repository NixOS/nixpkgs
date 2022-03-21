{ lib, fetchzip }:

let
  version = "0_995";
in fetchzip {
  name = "iwona-${version}";
  url = "http://jmn.pl/pliki/Iwona-otf-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile *.otf -d $out/share/fonts/opentype
  '';
  sha256 = "1dcpn13bd31dw7ir0s722bv3nk136dy6qsab0kznjbzfqd7agswa";

  meta = with lib; {
    description = "A two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "https://jmn.pl/en/kurier-i-iwona/";
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
