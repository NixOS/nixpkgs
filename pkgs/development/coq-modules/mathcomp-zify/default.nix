{ lib, mkCoqDerivation, coq, mathcomp-algebra, mathcomp-ssreflect,  mathcomp-fingroup, version ? null }:

mkCoqDerivation rec {
  namePrefix = [ "coq" "mathcomp" ];
  pname = "zify";
  repo = "mczify";
  owner = "math-comp";
  inherit version;

  defaultVersion = with lib.versions;
     lib.switch [ coq.coq-version mathcomp-algebra.version ] [
       { cases = [ (range "8.13" "8.16") (isGe "1.12") ]; out = "1.1.0+1.12+8.13"; }
     ] null;

  release."1.0.0+1.12+8.13".sha256 = "1j533vx6lacr89bj1bf15l1a0s7rvrx4l00wyjv99aczkfbz6h6k";
  release."1.1.0+1.12+8.13".sha256 = "1plf4v6q5j7wvmd5gsqlpiy0vwlw6hy5daq2x42gqny23w9mi2pr";

  propagatedBuildInputs = [ mathcomp-algebra mathcomp-ssreflect mathcomp-fingroup ];

  meta = {
    description = "Micromega tactics for Mathematical Components";
    maintainers = with lib.maintainers; [ cohencyril ];
  };
}
