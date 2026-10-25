{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "smproc";
  version = "2018-02-08";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "jameshaydon";
    repo = "smproc";
    rev = "b292d6c94fe005bcd984b8e5134b6f99933aa0af";
    hash = "sha256-NnSFlEx0fB0QdqPUP2nnf30d7UJP82v+25k3MZRQ+Ak=";
  };

  meta = {
    description = "Well-typed symmetric-monoidal category of concurrent processes";
    homepage = "https://github.com/jameshaydon/smproc";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
