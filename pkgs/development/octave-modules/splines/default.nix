{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "splines";
  version = "1.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "11a34f6a7615fc8x1smk3lx8vslilx4mrxi8f01la3wq68khnq5f";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/splines/index.html";
    license = with licenses; [ gpl3Plus publicDomain ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Additional spline functions";
  };
}
