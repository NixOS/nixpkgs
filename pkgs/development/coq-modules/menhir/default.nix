{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "menhir";
  owner = "fpottier";
  domain = "gitlab.inria.fr";
  inherit version;

  defaultVersion = let inherit (lib.versions) range; in
    lib.switch coq.coq-version [
      { case = range "8.20" "8.20"; out = "20240715"; }
      { case = range "8.7"  "8.19"; out = "20231231"; }
    ] null;
  release = {
    "20231231".sha256 = "sha256-veB0ORHp6jdRwCyDDAfc7a7ov8sOeHUmiELdOFf/QYk=";
    "20240715".sha256 = "sha256-9CSxAIm0aEXkwF+aj8u/bqLG30y5eDNz65EnohJPjzI=";
  };

  makeFlags = [ "-C coq-menhirlib" ];

  propagatedBuildInputs = [ coq.ocamlPackages.menhir ];

  meta = {
    description = "A support library for verified Coq parsers produced by Menhir";
    license = lib.licenses.lgpl3Plus;
  };
}
