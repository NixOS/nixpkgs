{ lib, mkCoqDerivation, coq, hydra-battles, pocklington, version ? null }:
with lib;

mkCoqDerivation {
  pname = "goedel";
  owner = "coq-community";

  releaseRev = (v: "v${v}");

  release."8.12.0".sha256 = "sha256-4lAwWFHGUzPcfHI9u5b+N+7mQ0sLJ8bH8beqQubfFEQ=";
  release."8.13.0".sha256 = "0sqqkmj6wsk4xmhrnqkhcsbsrqjzn2gnk67nqzgrmjpw5danz8y5";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.11" "8.15"; out = "8.13.0"; }
  ] null;

  propagatedBuildInputs = [ hydra-battles pocklington ];

  meta = {
    description = "The Gödel-Rosser 1st incompleteness theorem in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
