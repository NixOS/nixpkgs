{ buildOctavePackage
, lib
, fetchurl
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-JtXwR7bfFcRu6zRD1gGYG06Txmcu42w2C+zMXEiFf/U=";
  };

  requiredOctavePackages = [
    io
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/statistics/index.html";
    license = with licenses; [ gpl3Plus publicDomain ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Additional statistics functions for Octave";
  };
}
