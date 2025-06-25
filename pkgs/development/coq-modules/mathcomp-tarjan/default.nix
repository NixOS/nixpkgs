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
    with lib.versions;
    let
      cmc = c: mc: [
        c
        mc
      ];
    in
    lib.switch [ coq.coq-version mathcomp-ssreflect.version ] (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: cases: { inherit cases out; }) {
        "1.0.3" = cmc (range "8.16" "9.0") (range "2.0.0" "2.4.0");
        "1.0.2" = cmc (range "8.16" "9.0") (range "2.0.0" "2.3.0");
        "1.0.1" = cmc (range "8.12" "8.18") (range "1.12.0" "1.17.0");
        "1.0.0" = cmc (range "8.10" "8.16") (range "1.12.0" "1.17.0");
      }
    )) null;
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
