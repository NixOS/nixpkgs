{
  stdenv,
  lib,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "symmetrica";
  version = "3.1.0";

  # Fork of the original symmetrica, which can be found here
  # http://www.algorithm.uni-bayreuth.de/en/research/SYMMETRICA/index.html
  # "This fork was created to modernize the codebase, and to resume making
  # releases with the fixes that have accrued over the years."
  # Also see https://trac.sagemath.org/ticket/29061#comment:3.
  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "symmetrica";
    tag = version;
    hash = "sha256-unaNQfmDcQFUKApka7eEkjceurMnX0FICQXGDbOAOXo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # clang warning: passing arguments to '...' without a prototype is deprecated
  # in all versions of C and is not supported in C23.
  CFLAGS = "-std=c99 -Wno-deprecated-non-prototype";

  enableParallelBuilding = true;

  meta = {
    description = "Collection of routines for representation theory and combinatorics";
    license = lib.licenses.isc;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
    homepage = "https://gitlab.com/sagemath/symmetrica";
  };
}
