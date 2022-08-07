{ coq, mkCoqDerivation, mathcomp-ssreflect, mathcomp-fingroup,
  lib, version ? null }@args:
with lib; mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "tarjan";
  owner = "math-comp";

  inherit version;
  defaultVersion = with versions;
    switch [ coq.version mathcomp-ssreflect.version ] [{
      cases = [ (range "8.10" "8.15") (isGe "1.12.0") ]; out = "1.0.0";
  }] null;
  release."1.0.0".sha256 = "sha256:0r459r0makshzwlygw6kd4lpvdjc43b3x5y9aa8x77f2z5gymjq1";

  propagatedBuildInputs = [ mathcomp-ssreflect mathcomp-fingroup ];

  meta = {
    description = "Proofs of Tarjan and Kosaraju connected components algorithms";
    license = licenses.cecill-b;
  };
}
