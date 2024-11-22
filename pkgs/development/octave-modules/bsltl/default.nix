{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "bsltl";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0i8ry347y5f5db3702nhpsmfys9v18ks2fsmpdqpy3fcvrwaxdsb";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/bsltl/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Free collection of OCTAVE/MATLAB routines for working with the biospeckle laser technique";
  };
}
