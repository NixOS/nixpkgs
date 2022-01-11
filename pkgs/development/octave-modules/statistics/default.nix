{ buildOctavePackage
, lib
, fetchurl
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0iv2hw3zp7h69n8ncfjfgm29xaihdl5gp2slcw1yf23mhd7q2xkr";
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
