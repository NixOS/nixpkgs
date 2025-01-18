{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  seq,
  stdlib-shims,
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

  propagatedBuildInputs = [
    seq
    stdlib-shims
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy string searching, using Levenshtein automaton";
    license = licenses.bsd2;
    maintainers = [ maintainers.vbgl ];
  };
}
