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

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch
      [ coq.version mathcomp.version ]
      [
        {
          cases = [
            (isGe "8.16")
            (isGe "2.0")
          ];
          out = "1.3.1";
        }
        {
          cases = [
            (isGe "8.16")
            "2.0.0"
          ];
          out = "1.3.0";
        }
        {
          cases = [
            (isGe "8.11")
            (range "1.12" "1.19")
          ];
          out = "1.2.5";
        }
        {
          cases = [
            (isGe "8.11")
            (range "1.11" "1.14")
          ];
          out = "1.2.4";
        }
        {
          cases = [
            (isLe "8.13")
            (lib.pred.inter (isGe "1.11.0") (isLt "1.13"))
          ];
          out = "1.2.3";
        }
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.algebra
    mathcomp.ssreflect
    mathcomp.fingroup
  ];

  meta = with lib; {
    description = "Formal proof of the Four Color Theorem ";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
