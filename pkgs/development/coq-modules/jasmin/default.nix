{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  mathcomp-algebra-tactics,
  mathcomp-word,
  version ? null,
}:

mkCoqDerivation {
  pname = "jasmin";
  owner = "jasmin-lang";

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
        (case (range "8.19" "9.0") (range "2.2" "2.4") "2025.02.0")
        (case (isEq "8.18") (isEq "2.2") "2024.07.2")
      ]
      null;
  releaseRev = v: "v${v}";

  release."2025.02.0".sha256 = "sha256-Jlf0+VPuYWXdWyKHKHSp7h/HuCCp4VkcrgDAmh7pi5s=";
  release."2024.07.3".sha256 = "sha256-n/X8d7ILuZ07l24Ij8TxbQzAG7E8kldWFcUI65W4r+c=";
  release."2024.07.2".sha256 = "sha256-aF8SYY5jRxQ6iEr7t6mRN3BEmIDhJ53PGhuZiJGB+i8=";

  propagatedBuildInputs = [
    mathcomp-algebra-tactics
    mathcomp-word
  ];

  makeFlags = [
    "-C"
    "proofs"
  ];

  meta = with lib; {
    description = "Jasmin language & verified compiler";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = licenses.mit;
    maintainers = with maintainers; [
      proux01
      vbgl
    ];
  };
}
