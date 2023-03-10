{ buildOctavePackage
, lib
, fetchurl
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-mAG4tP6ybFhAfBNqk3mroeahBxOClwG7OVnZRzpn+gU=";
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
