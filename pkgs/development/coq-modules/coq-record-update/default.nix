{ lib, mkCoqDerivation, coq, version ? null , paco, coq-ext-lib }:

with lib; mkCoqDerivation rec {
  pname = "coq-record-update";
  owner = "tchajed";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.10" "8.15";  out = "0.3.0"; }
  ] null;
  release."0.3.0".sha256 = "1ffr21dd6hy19gxnvcd4if2450iksvglvkd6q5713fajd72hmc0z";
  releaseRev = v: "v${v}";
  buildFlags = "NO_TEST=1";
  meta = {
    description = "Library to create Coq record update functions";
    maintainers = with maintainers; [ ineol ];
  };
}
