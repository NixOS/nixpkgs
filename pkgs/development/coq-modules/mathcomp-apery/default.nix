{
  coq,
  mkCoqDerivation,
  mathcomp,
  coqeal,
  mathcomp-real-closed,
  mathcomp-bigenough,
  mathcomp-zify,
  mathcomp-algebra-tactics,
  lib,
  version ? null,
}:

mkCoqDerivation {

  pname = "apery";

  inherit version;
  defaultVersion =
    with lib.versions;
    let
      cmc = c: mc: [
        c
        mc
      ];
    in
    lib.switch [ coq.coq-version mathcomp.version ] (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: cases: { inherit cases out; }) {
        "1.0.2" = cmc (range "8.13" "8.16") (range "1.12.0" "1.17.0");
      }
    )) null;

  release."1.0.2".sha256 = "sha256-llxyMKYvWUA7fyroG1S/jtpioAoArmarR1edi3cikcY=";

  propagatedBuildInputs = [
    mathcomp.field
    coqeal
    mathcomp-real-closed
    mathcomp-bigenough
    mathcomp-zify
    mathcomp-algebra-tactics
  ];

  meta = {
    description = "Formally verified proof in Coq, by computer algebra, that ζ(3) is irrational";
    license = lib.licenses.cecill-c;
  };
}
