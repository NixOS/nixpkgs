{ buildOctavePackage
, lib
, fetchFromGitHub
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-cXAjUiv4xWPrWf7HQg9Y+JkR7ON9iefKFUGbEr9FGNA=";
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
