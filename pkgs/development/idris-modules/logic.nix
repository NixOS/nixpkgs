{
  build-idris-package,
  fetchFromGitHub,
  bifunctors,
  lib,
}:
build-idris-package {
  pname = "logic";
  version = "2016-12-02";

  idrisDeps = [ bifunctors ];

  src = fetchFromGitHub {
    owner = "yurrriq";
    repo = "idris-logic";
    rev = "e0bed57e17fde1237fe0358cb77b25f488a04d2f";
    hash = "sha256-33XqX8IyNt9IryAXTkiLjslD2CACCAcZ5XOHs8ENdk8=";
  };

  # tests fail
  doCheck = false;

  meta = {
    description = "Propositional logic tools, inspired by the Coq standard library";
    homepage = "https://github.com/yurrriq/idris-logic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
