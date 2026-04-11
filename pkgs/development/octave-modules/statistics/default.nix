{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
  datatypes,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    tag = "release-${version}";
    hash = "sha256-5wUQLIMr1X07Yi4AANBFjd0izDzGNsI5ccY7IherB3I=";
  };

  requiredOctavePackages = [
    io
    datatypes
  ];

  meta = {
    homepage = "https://packages.octave.org/statistics";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Statistics package for GNU Octave";
  };
}
