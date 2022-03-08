{ lib, mkCoqDerivation, coq, version ? null }:
with lib;

mkCoqDerivation rec {
  pname = "itauto";
  owner = "fbesson";
  domain = "gitlab.inria.fr";

  release."8.13+no".sha256 = "sha256-gXoxtLcHPoyjJkt7WqvzfCMCQlh6kL2KtCGe3N6RC/A=";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isEq "8.13"; out = "8.13+no"; }
  ] null;

  mlPlugin = true;
  extraNativeBuildInputs = (with coq.ocamlPackages; [ ocamlbuild ]);
  enableParallelBuilding = false;

  meta = {
    description = "A reflexive SAT solver parameterised by a leaf tactic and Nelson-Oppen support";
    maintainers = with maintainers; [ siraben ];
    license = licenses.gpl3Plus;
  };
}
