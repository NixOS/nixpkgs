{ lib, mkCoqDerivation, coq, mathcomp-algebra, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "mathcomp-zify";
  repo = "mczify";
  owner = "math-comp";
  inherit version;

  defaultVersion = with versions;
     switch [ coq.coq-version mathcomp-algebra.version ] [
       { cases = [ (range "8.13" "8.14") (isEq "1.12") ]; out = "1.1.0+1.12+8.13"; }
     ] null;

  release."1.0.0+1.12+8.13".sha256 = "1j533vx6lacr89bj1bf15l1a0s7rvrx4l00wyjv99aczkfbz6h6k";
  release."1.1.0+1.12+8.13".sha256 = "1plf4v6q5j7wvmd5gsqlpiy0vwlw6hy5daq2x42gqny23w9mi2pr";

  propagatedBuildInputs = [ mathcomp-algebra ];

  meta = {
    description = "Micromega tactics for Mathematical Components";
    maintainers = with maintainers; [ cohencyril ];
  };
}
