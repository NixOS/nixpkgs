{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "splines";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "16wisph8axc5xci0h51zj0y0x2wj6c9zybi2sjpb9v8z9dagjjqa";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/splines/index.html";
    license = with licenses; [ gpl3Plus publicDomain ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Additional spline functions";
  };
}
