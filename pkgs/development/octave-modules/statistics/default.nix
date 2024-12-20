{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "refs/tags/release-${version}";
    hash = "sha256-k1YJtFrm71Th42IceX7roWaFCxU3284Abl8JAKLG9So=";
  };

  requiredOctavePackages = [
    io
  ];

  meta = with lib; {
    homepage = "https://packages.octave.org/statistics";
    license = with licenses; [
      gpl3Plus
      publicDomain
    ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Statistics package for GNU Octave";
  };
}
