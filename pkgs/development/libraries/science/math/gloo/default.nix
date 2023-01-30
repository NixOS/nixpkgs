{ lib
, stdenv
, fetchFromGitHub
, cmake
, mpi
}:

stdenv.mkDerivation rec {
  pname = "gloo";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "gloo";
    # repo has no tags. use latest commit
    rev = "10909297fedab0a680799211a299203e53515032";
    sha256 = "sha256-jDn6AkvkkmlrdFKHxG+ObHnGZNp8x2+CatZJlMmvOuI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    mpi
  ];

  meta = {
    homepage = "https://github.com/facebookincubator/gloo";
    description = "Collective communications library with various primitives for multi-machine training";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
