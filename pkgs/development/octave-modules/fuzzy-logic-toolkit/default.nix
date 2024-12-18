{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "fuzzy-logic-toolkit";
  version = "0.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "126x0wjjqmwwgynsgjfdh5rlnww5bsl5hxq1xib15i58mrglh5cd";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/fuzzy-logic-toolkit/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Mostly MATLAB-compatible fuzzy logic toolkit for Octave";
  };
}
