{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    rev = "refs/tags/release-${version}";
    hash = "sha256-cXAjUiv4xWPrWf7HQg9Y+JkR7ON9iefKFUGbEr9FGNA=";
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
