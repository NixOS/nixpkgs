{
  build-idris-package,
  fetchFromGitHub,
  effects,
  contrib,
  lightyear,
  lib,
}:
build-idris-package {
  pname = "tlhydra";
  version = "2017-13-26";

  idrisDeps = [
    effects
    contrib
    lightyear
  ];

  src = fetchFromGitHub {
    owner = "Termina1";
    repo = "tlhydra";
    rev = "3fc9049447d9560fe16f4d36a2f2996494ac2b33";
    hash = "sha256-sHrgh3O/K92ifdXpbsS377jJjAV7cKD4BmBfH9hib/g=";
  };

  meta = {
    description = "Idris parser and serializer/deserealizer for TL language";
    homepage = "https://github.com/Termina1/tlhydra";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
