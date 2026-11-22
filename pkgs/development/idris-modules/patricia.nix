{
  build-idris-package,
  fetchFromGitHub,
  specdris,
  lib,
}:
build-idris-package {
  pname = "patricia";
  version = "2017-10-27";

  idrisDeps = [ specdris ];

  src = fetchFromGitHub {
    owner = "ChShersh";
    repo = "idris-patricia";
    rev = "24724e6d0564f2f813d0d0a58f5c5db9afe35313";
    hash = "sha256-H3tQ2ffmwTzKjYmlWYZgJLgPR3UfTI4v2nykXCUeeCQ=";
  };

  meta = {
    description = "Immutable map from integer keys to values based on patricia tree. Basically persistent array";
    homepage = "https://github.com/ChShersh/idris-patricia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
