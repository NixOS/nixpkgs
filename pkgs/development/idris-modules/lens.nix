{
  build-idris-package,
  fetchFromGitHub,
  bifunctors,
  lib,
}:
build-idris-package {
  pname = "lens";
  version = "2017-09-25";

  idrisDeps = [ bifunctors ];

  src = fetchFromGitHub {
    owner = "HuwCampbell";
    repo = "idris-lens";
    rev = "421aa76c19607693ac2f23003dc0fe82c1a3760a";
    hash = "sha256-sxpF9jXx+eSC/3HcNEiZXCjxIKlRjyI0Cg+HxjOs1OA=";
  };

  meta = {
    description = "van Laarhoven lenses for Idris";
    homepage = "https://github.com/HuwCampbell/idris-lens";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
