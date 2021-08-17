{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:

with lib; mkCoqDerivation {
  pname = "gaia";

  release."1.11".sha256 = "sha256:0gwb0blf37sv9gb0qpn34dab71zdcx7jsnqm3j9p58qw65cgsqn5";
  release."1.12".sha256 = "sha256:0c6cim4x6f9944g8v0cp0lxs244lrhb04ms4y2s6y1wh321zj5mi";
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ] [
    { cases = [ (range "8.10" "8.13") "1.12.0" ]; out = "1.12"; }
    { cases = [ (range "8.10" "8.12") "1.11.0" ]; out = "1.11"; }
  ] null;

  propagatedBuildInputs =
    [ mathcomp.ssreflect mathcomp.algebra ];

  meta = {
    description = "Implementation of books from Bourbaki's Elements of Mathematics in Coq";
    maintainers = with maintainers; [ Zimmi48 ];
    license = licenses.mit;
  };
}
