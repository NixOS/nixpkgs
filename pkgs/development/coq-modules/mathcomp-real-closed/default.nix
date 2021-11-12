{ coq, mkCoqDerivation, mathcomp, mathcomp-bigenough,
  lib, version ? null }:

with lib; mkCoqDerivation {

  namePrefix = [ "coq" "mathcomp" ];
  pname = "real-closed";
  owner = "math-comp";
  inherit version;
  release = {
    "1.1.2".sha256 = "0907x4nf7nnvn764q3x9lx41g74rilvq5cki5ziwgpsdgb98pppn";
    "1.1.1".sha256 = "0ksjscrgq1i79vys4zrmgvzy2y4ylxa8wdsf4kih63apw6v5ws6b";
    "1.0.5".sha256 = "0q8nkxr9fba4naylr5xk7hfxsqzq2pvwlg1j0xxlhlgr3fmlavg2";
    "1.0.4".sha256 = "058v9dj973h9kfhqmvcy9a6xhhxzljr90cf99hdfcdx68fi2ha1b";
    "1.0.3".sha256 = "1xbzkzqgw5p42dx1liy6wy8lzdk39zwd6j14fwvv5735k660z7yb";
    "1.0.1".sha256 = "0j81gkjbza5vg89v4n9z598mfdbql416963rj4b8fzm7dp2r4rxg";
  };

  defaultVersion = with versions; switch [ coq.version mathcomp.version ]  [
      { cases = [ (isGe "8.10")  (isGe "1.12.0") ]; out = "1.1.2"; }
      { cases = [ (isGe "8.7")   "1.11.0" ]; out = "1.1.1"; }
      { cases = [ (isGe "8.7")   (range "1.9.0" "1.10.0") ]; out = "1.0.4"; }
      { cases = [ (isGe "8.7")   "1.8.0"  ]; out = "1.0.3"; }
      { cases = [ (isGe "8.7")   "1.7.0"  ]; out = "1.0.1"; }
    ] null;

  propagatedBuildInputs = [ mathcomp.ssreflect mathcomp.field mathcomp-bigenough ];

  meta = {
    description = "Mathematical Components Library on real closed fields";
    license = licenses.cecill-c;
  };
}
