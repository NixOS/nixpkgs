{ lib, fetchFromGitHub, buildDunePackage
, seq
}:

buildDunePackage rec {
  pname = "spelll";
  version = "0.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "03adqisgsazsxdkrypp05k3g91hydfgcif2014il63gdbd9nhzlh";
  };

  propagatedBuildInputs = [ seq ];

  meta = {
    inherit (src.meta) homepage;
    description = "Fuzzy string searching, using Levenshtein automaton";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
