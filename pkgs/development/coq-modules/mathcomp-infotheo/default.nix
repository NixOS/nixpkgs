{
  coq,
  mkCoqDerivation,
  mathcomp-analysis,
  mathcomp-analysis-stdlib,
  mathcomp-algebra-tactics,
  interval,
  lib,
  version ? null,
}:

(mkCoqDerivation {
  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "infotheo";
  owner = "affeldt-aist";
  inherit version;

  defaultVersion =
    with lib.versions;
    lib.switch
      [ coq.version mathcomp-analysis.version ]
      [
        {
          cases = [
            (range "8.19" "8.20")
            (isGe "1.7")
          ];
          out = "0.7.5";
        }
        {
          cases = [
            (range "8.18" "8.20")
            (isGe "1.5")
          ];
          out = "0.7.3";
        }
        {
          cases = [
            (range "8.18" "8.19")
            (isGe "1.2")
          ];
          out = "0.7.2";
        }
        {
          cases = [
            (range "8.17" "8.19")
            (isGe "1.0")
          ];
          out = "0.7.1";
        }
        {
          cases = [
            (isGe "8.17")
            (range "0.6.6" "0.7.0")
          ];
          out = "0.6.1";
        }
        {
          cases = [
            (range "8.17" "8.18")
            (range "0.6.0" "0.6.7")
          ];
          out = "0.5.2";
        }
        {
          cases = [
            (range "8.15" "8.16")
            (range "0.5.4" "0.6.5")
          ];
          out = "0.5.1";
        }
      ]
      null;
  release."0.7.5".sha256 = "sha256-pzPo+Acjx3vlyqOkSZQ8uT2BDLSTfbAnRm39e+/CqE0=";
  release."0.7.3".sha256 = "sha256-7+qPtE1KfDmo9ZsQtWMzoR2MYnFpTjFHK/yZYVm+GxA=";
  release."0.7.2".sha256 = "sha256-dekrdVmuTcqXXmKhIb831EKtMhbPrXHJZhzmGb9rdRo=";
  release."0.7.1".sha256 = "sha256-/4Elb35SmscG6EjEcHYDo+AmWrpBUlygZL0WhaD+fcY=";
  release."0.6.1".sha256 = "sha256-tFB5lrwRPIlHkP+ebgcJwu03Cc9yVaOINOAo8Bf2LT4=";
  release."0.5.1".sha256 = "sha256-yBBl5l+V+dggsg5KM59Yo9CULKog/xxE8vrW+ZRnX7Y=";
  release."0.5.2".sha256 = "sha256-8WAnAV53c0pMTdwj8XcUDUkLZbpUgIQbEOgOb63uHQA=";

  propagatedBuildInputs = [ mathcomp-analysis-stdlib ];

  meta = with lib; {
    description = "Coq formalization of information theory and linear error-correcting codes";
    license = licenses.lgpl21Plus;
  };
}).overrideAttrs
  (o: {
    propagatedBuildInputs =
      o.propagatedBuildInputs
      ++ lib.optional (lib.versions.isGe "0.6.1" o.version || o.version == "dev") mathcomp-algebra-tactics
      ++ lib.optional (lib.versions.isGe "0.7.2" o.version || o.version == "dev") interval;
  })
