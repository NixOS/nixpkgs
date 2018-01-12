{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "iwona-${version}";
  version = "0_995";

  src = fetchzip {
    url = "http://jmn.pl/pliki/Iwona-otf-${version}.zip";
    sha256 = "1wj5bxbxpz5a8p3rhw708cyjc0lgqji8g0iv6brmmbrrkpb3jq2s";
  };

  installPhase = ''
    install -m 444 -D -t $out/share/fonts/opentype/ *.otf
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1dcpn13bd31dw7ir0s722bv3nk136dy6qsab0kznjbzfqd7agswa";

  meta = with stdenv.lib; {
    description = "A two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = http://jmn.pl/en/kurier-i-iwona/;
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
