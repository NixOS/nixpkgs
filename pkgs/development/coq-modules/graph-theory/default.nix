{ lib, mkCoqDerivation, coq, mathcomp-algebra, mathcomp-finmap, mathcomp-fingroup
, fourcolor, hierarchy-builder, version ? null }:

mkCoqDerivation {
  pname = "graph-theory";

  release."0.9".sha256 = "sha256-Hl3JS9YERD8QQziXqZ9DqLHKp63RKI9HxoFYWSkJQZI=";
  release."0.9.1".sha256 = "sha256-lRRY+501x+DqNeItBnbwYIqWLDksinWIY4x/iojRNYU=";

  releaseRev = v: "v${v}";

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.14" "8.16"; out = "0.9.1"; }
    { case = range "8.12" "8.12"; out = "0.9"; }
  ] null;

  propagatedBuildInputs = [ mathcomp-algebra mathcomp-finmap mathcomp-fingroup fourcolor hierarchy-builder ];

  meta = with lib; {
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
