{ lib, mkCoqDerivation, coq, mathcomp-algebra, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "mathcomp-zify";
  repo = "mczify";
  owner = "math-comp";
  inherit version;

  defaultVersion = with versions;
     switch [ coq.coq-version mathcomp-algebra.version ] [
       { cases = [ (isEq "8.13") (isEq "1.12") ]; out = "1.0.0+1.12+8.13"; }
     ] null;

  release."1.0.0+1.12+8.13".sha256 = "1j533vx6lacr89bj1bf15l1a0s7rvrx4l00wyjv99aczkfbz6h6k";

  propagatedBuildInputs = [ mathcomp-algebra ];

  meta = {
    description = "Micromega tactics for Mathematical Components";
    maintainers = with maintainers; [ cohencyril ];
  };
}
