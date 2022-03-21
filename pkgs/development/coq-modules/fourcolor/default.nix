{ lib, mkCoqDerivation, coq, mathcomp, version ? null }:
with lib;

mkCoqDerivation {
  pname = "fourcolor";
  owner = "math-comp";

  release."1.2.3".rev    = "v1.2.3";
  release."1.2.3".sha256 = "sha256-gwKfUa74fIP7j+2eQgnLD7AswjCtOFGHGaIWb4qI0n4=";
  release."1.2.4".rev    = "v1.2.4";
  release."1.2.4".sha256 = "sha256-iSW2O1kuunvOqTolmGGXmsYTxo2MJYCdW3BnEhp6Ksg=";

  inherit version;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ] [
    { cases = [ (isGe "8.11") (isGe "1.11.0") ]; out = "1.2.4"; }
    { cases = [ (isLe "8.13") (pred.inter (isGe "1.11.0") (isLt "1.13")) ]; out = "1.2.3"; }
  ] null;

  propagatedBuildInputs = [ mathcomp.algebra mathcomp.ssreflect mathcomp.fingroup ];

  meta = {
    description = "Formal proof of the Four Color Theorem ";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
