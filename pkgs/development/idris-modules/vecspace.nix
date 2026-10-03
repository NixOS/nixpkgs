{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "vecspace";
  version = "2018-01-12";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "clayrat";
    repo = "idris-vecspace";
    rev = "6830fa13232f25e9874b3f857b79508b5f82cb99";
    hash = "sha256-Ak/+4wagrE4cL7hALQA8XxCgwH0CY2/pgZ6uX1kyn7c=";
  };

  meta = {
    description = "Abstract vector spaces in Idris";
    homepage = "https://github.com/clayrat/idris-vecspace";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
