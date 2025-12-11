{
  coq,
  mkCoqDerivation,
  mathcomp-ssreflect,
  mathcomp-fingroup,
  lib,
  version ? null,
}@args:

mkCoqDerivation {

  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "tarjan";
  owner = "math-comp";

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
      [ coq.coq-version mathcomp-ssreflect.version ]
      [
        (case (range "8.16" "9.1") (range "2.0.0" "2.5.0") "1.0.4")
        (case (range "8.16" "9.1") (range "2.0.0" "2.4.0") "1.0.3")
        (case (range "8.16" "9.0") (range "2.0.0" "2.3.0") "1.0.2")
        (case (range "8.12" "8.18") (range "1.12.0" "1.17.0") "1.0.1")
        (case (range "8.10" "8.16") (range "1.12.0" "1.17.0") "1.0.0")
      ]
      null;
  release."1.0.4".sha256 = "sha256-fvE53jJe7/kQUI+lhO6lKdWfsFfRjOk2YGOcHUoJ6BU=";
  release."1.0.3".sha256 = "sha256-5lpOCDyH6NFzGLvnXHHAnR7Qv5oXsUyC8TLBFrIiBag=";
  release."1.0.2".sha256 = "sha256-U20xgA+e9KTRdvILD1cxN6ia+dlA8uBTIbc4QlKz9ss=";
  release."1.0.1".sha256 = "sha256-utNjFCAqC5xOuhdyKhfMZkRYJD0xv9Gt6U3ZdQ56mek=";
  release."1.0.0".sha256 = "sha256:0r459r0makshzwlygw6kd4lpvdjc43b3x5y9aa8x77f2z5gymjq1";

  propagatedBuildInputs = [
    mathcomp-ssreflect
    mathcomp-fingroup
  ];

  meta = {
    description = "Proofs of Tarjan and Kosaraju connected components algorithms";
    license = lib.licenses.cecill-b;
  };
}
