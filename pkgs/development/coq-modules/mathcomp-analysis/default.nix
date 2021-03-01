{ coq, mkCoqDerivation, mathcomp, mathcomp-finmap, mathcomp-bigenough, mathcomp-real-closed,
  lib, version ? null }:

with lib; mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "analysis";
  owner = "math-comp";

  release."0.3.1".sha256 = "1iad288yvrjv8ahl9v18vfblgqb1l5z6ax644w49w9hwxs93f2k8";
  release."0.2.3".sha256 = "0p9mr8g1qma6h10qf7014dv98ln90dfkwn76ynagpww7qap8s966";

  inherit version;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ]  [
      { cases = [ (range "8.10" "8.11") "1.11.0" ];             out = "0.3.1"; }
      { cases = [ (range "8.8"  "8.11") (range "1.8" "1.10") ]; out = "0.2.3"; }
    ] null;

  propagatedBuildInputs =
    [ mathcomp.ssreflect mathcomp.field
      mathcomp-finmap mathcomp-bigenough mathcomp-real-closed ];

  meta = {
    description = "Analysis library compatible with Mathematical Components";
    maintainers = [ maintainers.cohencyril ];
    license = licenses.cecill-c;
  };
}
