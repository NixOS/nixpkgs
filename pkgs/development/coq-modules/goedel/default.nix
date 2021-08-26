{ lib, mkCoqDerivation, coq, hydra-battles, pocklington, version ? null }:
with lib;

mkCoqDerivation {
  pname = "goedel";
  owner = "coq-community";

  release."8.12.0".rev    = "v8.12.0";
  release."8.12.0".sha256 = "sha256-4lAwWFHGUzPcfHI9u5b+N+7mQ0sLJ8bH8beqQubfFEQ=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.11"; out = "8.12.0"; }
  ] null;

  propagatedBuildInputs = [ hydra-battles pocklington ];

  meta = {
    description = "The Gödel-Rosser 1st incompleteness theorem in Coq";
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
