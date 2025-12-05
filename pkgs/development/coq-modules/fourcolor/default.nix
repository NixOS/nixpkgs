{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  version ? null,
}:

mkCoqDerivation {
  pname = "fourcolor";
  owner = "math-comp";

  releaseRev = v: "v${v}";

  release."1.2.3".sha256 = "sha256-gwKfUa74fIP7j+2eQgnLD7AswjCtOFGHGaIWb4qI0n4=";
  release."1.2.4".sha256 = "sha256-iSW2O1kuunvOqTolmGGXmsYTxo2MJYCdW3BnEhp6Ksg=";
  release."1.2.5".sha256 = "sha256-3qOPNCRjGK2UdHGMSqElpIXhAPVCklpeQgZwf9AFals=";
  release."1.3.0".sha256 = "sha256-h9pa6vaKT6jCEaIdEdcu0498Ou5kEXtZdb9P7WXK1DQ=";
  release."1.3.1".sha256 = "sha256-wBizm1hJXPYBu0tHFNScQHd22FebsJYoggT5OlhY/zM=";
  release."1.4.0".sha256 = "sha256-8TtNPEbp3uLAH+MjOKiTZHOjPb3vVYlabuqsdWxbg80=";
  release."1.4.1".sha256 = "sha256-0UASpo9CdpvidRv33BDWrevo+NSOhxLQFPCJAWPXf+s=";
  release."1.4.2".sha256 = "sha256-d5J8j8gi6siwCLevM6y8Hf2rTB/HEfh72LLk0Qlzr0c=";

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
        (case (isGe "8.20") (isGe "2.4") "1.4.2")
        (case (isGe "8.16") (isGe "2.0") "1.4.1")
        (case (isGe "8.16") "2.0.0" "1.3.0")
        (case (isGe "8.11") (range "1.12" "1.19") "1.2.5")
        (case (isGe "8.11") (range "1.11" "1.14") "1.2.4")
        (case (isLe "8.13") (lib.pred.inter (isGe "1.11.0") (isLt "1.13")) "1.2.3")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.boot
    mathcomp.fingroup
    mathcomp.algebra
  ];

  meta = with lib; {
    description = "Formal proof of the Four Color Theorem";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
