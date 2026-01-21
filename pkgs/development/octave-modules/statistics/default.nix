{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    tag = "release-${version}";
    hash = "sha256-4nwkrnYaFdBkLLbIUJX0U4tytHrSIKltWu7Srx43K5g=";
  };

  requiredOctavePackages = [
    io
  ];

  meta = {
    homepage = "https://packages.octave.org/statistics";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Statistics package for GNU Octave";
  };
}
