{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "divand";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0nmaz5j37dflz7p4a4lmwzkh7g1gghdh7ccvkbyy0fpgv9lr1amg";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/divand/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Performs an n-dimensional variational analysis (interpolation) of arbitrarily located observations";
  };
}
