{ buildOctavePackage
, lib
, fetchFromGitHub
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-gFauFIaXKzcPeNvpWHv5FAxYQvZNh7ELrSUIvn43IfQ=";
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
