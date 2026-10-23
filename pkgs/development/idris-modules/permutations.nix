{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "permutations";
  version = "2018-01-19";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "permutations";
    rev = "f0de6bc721bb9d31e16f9168ded6eb6e34935881";
    hash = "sha256-Ouz/+hY4M0pSMLT81Nku2Gr8aShZivsOX585QDz+ObY=";
  };

  meta = {
    description = "Type-safe way of working with permutations in Idris";
    homepage = "https://github.com/vmchale/permutations";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
