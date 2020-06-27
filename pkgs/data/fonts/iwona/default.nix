{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "iwona";
  version = "0_995";

  src = fetchzip {
    url = "http://jmn.pl/pliki/Iwona-otf-${version}.zip";
    sha256 = "1wj5bxbxpz5a8p3rhw708cyjc0lgqji8g0iv6brmmbrrkpb3jq2s";
  };

  meta = with lib; {
    description = "A two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "http://jmn.pl/en/kurier-i-iwona/";
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
