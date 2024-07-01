{ buildOctavePackage
, lib
, fetchFromGitHub
, io
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "refs/tags/release-${version}";
    sha256 = "sha256-n7tfc67PiFDuWh+7w93RwGzdR6cg81xLp0ILOlundnU=";
  };

  requiredOctavePackages = [
    io
  ];

  meta = with lib; {
    homepage = "https://packages.octave.org/statistics";
    license = with licenses; [ gpl3Plus publicDomain ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "The Statistics package for GNU Octave.";
  };
}
