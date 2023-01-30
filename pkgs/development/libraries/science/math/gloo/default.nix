{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "gloo";
  version = "unstable-2022-10-17";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "gloo";
    # repo has no tags. use latest commit with passing tests
    rev = "a01540ec3dabd085ad2579aa2b7a004406e2793b";
    sha256 = "sha256-ks4tac6JuV2cEhihayE2zm0Pq6slrzW+7CHDSg3BDOc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/facebookincubator/gloo";
    description = "Collective communications library with various primitives for multi-machine training";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
