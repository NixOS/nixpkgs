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
    sha256 = "0n1kqpxysl3dji0zd8c47ir4144s0n3pb8i1mqp6ylma3r7rlg1l";
  };

  meta = {
    description = "Comonads for Idris";
    homepage = "https://github.com/ctford/flying-spaghetti-monster";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
