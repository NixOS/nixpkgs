{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "fuzzy-logic-toolkit";
  version = "0.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0cs1xh594h1psdinicxrsvm27gzax5jja7bjk4sl3kk2hv24mhml";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/fuzzy-logic-toolkit/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "A mostly MATLAB-compatible fuzzy logic toolkit for Octave";
  };
}
