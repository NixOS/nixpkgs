{ lib, mkCoqDerivation, coq, parsec, MenhirLib, version ? null }:

mkCoqDerivation {
  pname = "json";
  owner = "liyishuai";
  repo = "coq-json";
  inherit version;

  defaultVersion = let inherit (lib.versions) range; in
    lib.switch coq.coq-version [
      { case = range "8.14" "8.20"; out = "0.1.3"; }
    ] null;
  release = {
    "0.1.3".sha256  = "sha256-lElAzW4IuX+BB6ngDjlyKn0MytLRfbhQanB+Lct/WR0=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ parsec MenhirLib coq.ocamlPackages.menhir ];

  buildFlags = [ "MENHIRFLAGS=--coq" "MENHIRFLAGS+=--coq-no-version-check" ];

  meta = {
    description = "From JSON to Coq, and vice versa.";
    license = lib.licenses.bsd3;
  };
}
