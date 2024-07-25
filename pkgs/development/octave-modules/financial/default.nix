{ buildOctavePackage
, lib
, fetchurl
, io
, statistics
}:

buildOctavePackage rec {
  pname = "financial";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0f963yg6pwvrdk5fg7b71ny47gzy48nqxdzj2ngcfrvmb5az4vmf";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/financial/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Monte Carlo simulation, options pricing routines, financial manipulation, plotting functions and additional date manipulation tools";
  };
}
