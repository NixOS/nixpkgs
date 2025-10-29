{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  mathcomp-finmap,
  mathcomp-algebra-tactics,
  fourcolor,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "graph-theory";

  release."0.9".sha256 = "sha256-Hl3JS9YERD8QQziXqZ9DqLHKp63RKI9HxoFYWSkJQZI=";
  release."0.9.1".sha256 = "sha256-lRRY+501x+DqNeItBnbwYIqWLDksinWIY4x/iojRNYU=";
  release."0.9.2".sha256 = "sha256-DPYCZS8CzkfgpR+lmYhV2v20ezMtyWp8hdWpuh0OOQU=";
  release."0.9.3".sha256 = "sha256-9WX3gsw+4btJLqcGg2W+7Qy+jaZtkfw7vCp8sXYmaWw=";
  release."0.9.4".sha256 = "sha256-fXTAsRdPisNhg8Umaa7S7gZ1M8zuPGg426KP9fAkmXQ=";
  release."0.9.6".sha256 = "sha256-fvGb970tRE4xj1pBIhNBDaqssDd6kNQ/+s0c+aOO5IE=";

  releaseRev = v: "v${v}";

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp.version ]
      [
        (case (range "8.18" "9.0") (range "2.0.0" "2.4.0") "0.9.6")
        (case (range "8.16" "8.19") (range "2.0.0" "2.3.0") "0.9.4")
        (case (range "8.16" "8.18") (range "2.0.0" "2.1.0") "0.9.3")
        (case (range "8.14" "8.18") (range "1.13.0" "1.18.0") "0.9.2")
        (case (range "8.14" "8.16") (range "1.13.0" "1.14.0") "0.9.1")
        (case (range "8.12" "8.13") (range "1.12.0" "1.14.0") "0.9")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.algebra
    mathcomp-finmap
    mathcomp.fingroup
    mathcomp-algebra-tactics
    fourcolor
    stdlib
  ];

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
