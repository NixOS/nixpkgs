{ lib, fetchFromGitHub, buildDunePackage
, seq
, stdlib-shims
}:

buildDunePackage rec {
  pname = "spelll";
  version = "0.4";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nI8fdArYynR70PUJIgyogGBCe4gFhfVzuRdZzFGKqOc=";
  };

  propagatedBuildInputs = [ seq stdlib-shims ];

  meta = {
    inherit (src.meta) homepage;
    description = "Fuzzy string searching, using Levenshtein automaton";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
