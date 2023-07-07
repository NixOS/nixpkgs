{ lib, mkCoqDerivation, coq, mathcomp-algebra,
  coq-elpi, mathcomp-zify, version ? null }:

mkCoqDerivation {
  namePrefix = [ "coq" "mathcomp" ];
  pname = "algebra-tactics";
  owner = "math-comp";
  inherit version;

  defaultVersion = with lib.versions;
     lib.switch [ coq.coq-version mathcomp-algebra.version ] [
       { cases = [ (range "8.16" "8.17") (isGe "1.15") ]; out = "1.1.1"; }
       { cases = [ (range "8.13" "8.16") (isGe "1.12") ]; out = "1.0.0"; }
     ] null;

  release."1.0.0".sha256 = "sha256-kszARPBizWbxSQ/Iqpf2vLbxYc6AjpUCLnSNlPcNfls=";
  release."1.1.1".sha256 = "sha256-5wItMeeTRoJlRBH3zBNc2VUZn6pkDde60YAvXTx+J3U=";

  propagatedBuildInputs = [ mathcomp-algebra coq-elpi mathcomp-zify ];

  meta = {
    description = "Ring and field tactics for Mathematical Components";
    maintainers = with lib.maintainers; [ cohencyril ];
  };
}
