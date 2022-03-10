{ lib, mkCoqDerivation, coq, mathcomp-algebra, mathcomp-finmap, mathcomp-fingroup
, hierarchy-builder, version ? null }:

with lib;

mkCoqDerivation {
  pname = "graph-theory";

  release."0.9".sha256 = "sha256-Hl3JS9YERD8QQziXqZ9DqLHKp63RKI9HxoFYWSkJQZI=";

  releaseRev = v: "v${v}";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.13" "8.14"; out = "0.9"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-algebra mathcomp-finmap mathcomp-fingroup hierarchy-builder ];

  meta = {
    description = "Library of formalized graph theory results in Coq";
    longDescription = ''
      A library of formalized graph theory results, including various
      standard results from the literature (e.g., Menger’s Theorem, Hall’s
      Marriage Theorem, and the excluded minor characterization of
      treewidth-two graphs) as well as some more recent results arising from
      the study of relation algebra within the ERC CoVeCe project (e.g.,
      soundness and completeness of an axiomatization of graph isomorphism).
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
  };
}
