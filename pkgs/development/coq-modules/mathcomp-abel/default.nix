{ coq, mkCoqDerivation, mathcomp, mathcomp-real-closed, lib, version ? null }:

mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "abel";
  owner = "math-comp";

  release."1.0.0".sha256 = "190jd8hb8anqsvr9ysr514pm5sh8qhw4030ddykvwxx9d9q6rbp3";

  inherit version;
  defaultVersion = with lib; with versions; switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.10" "8.13") (range "1.11.0" "1.12.0") ]; out = "1.0.0"; }
    ] null;

  propagatedBuildInputs = [ mathcomp.field mathcomp-real-closed ];

  meta = with lib; {
    description = "Abel - Galois and Abel - Ruffini Theorems";
    license = licenses.cecill-b;
    maintainers = [ maintainers.cohencyril ];
  };
}
