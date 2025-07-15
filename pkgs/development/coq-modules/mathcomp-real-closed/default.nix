{
  coq,
  mkCoqDerivation,
  mathcomp,
  mathcomp-bigenough,
  lib,
  version ? null,
}:

mkCoqDerivation {

  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "real-closed";
  owner = "math-comp";
  inherit version;
  release = {
    "2.0.3".sha256 = "sha256-heZ7aZ7TO9YNAESIvbAc1qqzO91xMyLAox8VKueIk/s=";
    "2.0.2".sha256 = "sha256-hBo9JMtmXDYBmf5ihKGksQLHv3c0+zDBnd8/aI2V/ao=";
    "2.0.1".sha256 = "sha256-tQTI3PCl0q1vWpps28oATlzOI8TpVQh1jhTwVmhaZic=";
    "2.0.0".sha256 = "sha256-sZvfiC5+5Lg4nRhfKKqyFzovCj2foAhqaq/w9F2bdU8=";
    "1.1.4".sha256 = "sha256-8Hs6XfowbpeRD8RhMRf4ZJe2xf8kE0e8m7bPUzR/IM4=";
    "1.1.3".sha256 = "1vwmmnzy8i4f203i2s60dn9i0kr27lsmwlqlyyzdpsghvbr8h5b7";
    "1.1.2".sha256 = "0907x4nf7nnvn764q3x9lx41g74rilvq5cki5ziwgpsdgb98pppn";
    "1.1.1".sha256 = "0ksjscrgq1i79vys4zrmgvzy2y4ylxa8wdsf4kih63apw6v5ws6b";
    "1.0.5".sha256 = "0q8nkxr9fba4naylr5xk7hfxsqzq2pvwlg1j0xxlhlgr3fmlavg2";
    "1.0.4".sha256 = "058v9dj973h9kfhqmvcy9a6xhhxzljr90cf99hdfcdx68fi2ha1b";
    "1.0.3".sha256 = "1xbzkzqgw5p42dx1liy6wy8lzdk39zwd6j14fwvv5735k660z7yb";
    "1.0.1".sha256 = "0j81gkjbza5vg89v4n9z598mfdbql416963rj4b8fzm7dp2r4rxg";
  };

  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.version mathcomp.version ]
      [
        (case (range "8.18" "9.1") (isGe "2.2.0") "2.0.3")
        (case (range "8.17" "9.0") (range "2.1.0" "2.3.0") "2.0.2")
        (case (range "8.17" "8.20") (range "2.0.0" "2.2.0") "2.0.1")
        (case (range "8.16" "8.19") (range "2.0.0" "2.2.0") "2.0.0")
        (case (range "8.13" "8.19") (range "1.13.0" "1.19.0") "1.1.4")
        (case (isGe "8.13") (range "1.12.0" "1.18.0") "1.1.3")
        (case (isGe "8.10") (range "1.12.0" "1.18.0") "1.1.2")
        (case (isGe "8.7") "1.11.0" "1.1.1")
        (case (isGe "8.7") (range "1.9.0" "1.10.0") "1.0.4")
        (case (isGe "8.7") "1.8.0" "1.0.3")
        (case (isGe "8.7") "1.7.0" "1.0.1")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.ssreflect
    mathcomp.algebra
    mathcomp.field
    mathcomp.fingroup
    mathcomp.solvable
    mathcomp-bigenough
  ];

  meta = {
    description = "Mathematical Components Library on real closed fields";
    license = lib.licenses.cecill-c;
  };
}
