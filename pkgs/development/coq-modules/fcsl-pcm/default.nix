{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp-algebra,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "fcsl-pcm";
  owner = "imdea-software";
  inherit version;

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
      [ coq.coq-version mathcomp-algebra.version ]
      [
        (case (range "9.0" "9.1") (range "2.4.0" "2.5.0") "2.2.0")
      ]
      null;
  release."2.2.0".sha256 = "sha256-VnfK+RHWiq27hxEJ9stpVp609/dMiPH6UHFhzaHdAnM=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    mathcomp-algebra
    stdlib
  ];

  meta = {
    description = "Coq library of Partial Commutative Monoids";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.proux01 ];
  };
}
