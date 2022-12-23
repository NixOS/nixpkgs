{ buildOctavePackage
, lib
, fetchFromGitHub
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "release-${version}";
    sha256 = "sha256-+Eye29vH4HBfaZRzRNY6J0+wWjh6aCvnq7hZ7M34L2M=";
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
