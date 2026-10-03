{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "fsm";
  version = "2017-04-16";

  src = fetchFromGitHub {
    owner = "ctford";
    repo = "flying-spaghetti-monster";
    rev = "9253db1048d155b9d72dd5319f0a2072b574d406";
    hash = "sha256-NDyaTx6qUm8uriGidYcFmpBAcjyEofZBlG1Q7fvFM1g=";
  };

  meta = {
    description = "Comonads for Idris";
    homepage = "https://github.com/ctford/flying-spaghetti-monster";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
