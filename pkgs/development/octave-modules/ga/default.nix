{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "ga";
  version = "0.10.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-cbP7ucua7DdxLL422INxjZxz/x1pHoIq+jkjrtfaabE=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/ga/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Genetic optimization code";
  };
}
