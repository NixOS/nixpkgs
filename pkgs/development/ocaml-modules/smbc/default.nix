{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  containers,
  iter,
  msat,
  menhir,
  result,
}:

let
  tip-parser = buildDunePackage {
    pname = "tip-parser";
    version = "0.6-unstable-2019-06-14";

    minimalOCamlVersion = "4.03";

    src = fetchFromGitHub {
      owner = "c-cube";
      repo = "tip-parser";
      rev = "7d2bad590db96a2aff7815e75ccf1a51e887d326";
      hash = "sha256-y4fYh7TXrOaCLZJGar3sj/CTY7lJP9vRXqz9dDwFeGI=";
    };

    nativeBuildInputs = [ menhir ];
    propagatedBuildInputs = [ result ];

    patches = [ ./fix-menhir-and-deps.patch ];

    meta = {
      description = "Obsolete parser for tip files";
      homepage = "https://c-cube.github.io/tip-parser/";
      license = lib.licenses.bsd2;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ sempiternal-aurora ];
    };
  };
in

buildDunePackage {
  pname = "smbc";
  version = "0.6.1-unstable-2022-06-23";

  minimalOcamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "smbc";
    rev = "930278367b0a4a46eb0378455fe78dc99fc3133e";
    hash = "sha256-/etemk6bNeYzG6eijCU5rTJ4z9AhN/gtKWg8PmRlO1Q=";
  };

  buildInputs = [
    containers
    iter
    msat
    tip-parser
  ];

  passthru = {
    inherit tip-parser;
  };

  meta = {
    description = "Experimental model finder/SMT solver for functional programming.";
    homepage = "https://nunchaku-inria.github.io/nunchaku/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
    mainProgram = "smbc";
  };
}
