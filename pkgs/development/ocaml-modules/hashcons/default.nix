{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "hashcons";
  version = "1.4";

  src = fetchFromGitHub {
    owner  = "backtracking";
    repo   = "ocaml-${pname}";
    rev    = "d733325eeb55878bed285120c2c088daf78f0e2b";
    sha256 = "0h4pvwj34pndaw3pajkhl710ywwinhc9pqimgllfmkl37wz2d8zq";
  };

  useDune2 = true;

  doCheck = true;

  meta = {
    description = "OCaml hash-consing library";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
