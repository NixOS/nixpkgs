{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "coq-record-update";
  owner = "tchajed";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "8.14" "9.1") "0.3.6")
      (case (range "8.10" "9.1") "0.3.4")
    ] null;
  release."0.3.6".sha256 = "sha256-Sd9cmRPb/0MDlR9mzbFrrF9ifP/2vd0KG6u5fGOydds=";
  release."0.3.5".sha256 = "sha256-n2HjGD45Ikwhle8jKjum+Hv+4WrpEqKEbJ6iKfwlQKw=";
  release."0.3.4".sha256 = "sha256-AhEcugUiVIsgbq884Lur/bQIuGw8prk+3AlNkP1omcw=";
  release."0.3.3".sha256 = "sha256-HDIPeFHiC9EwhiOH7yMGJ9d2zJMhboTpRGf9kWcB9Io=";
  release."0.3.1".sha256 = "sha256-DyGxO2tqmYZZluXN6Oy5Tw6fuLMyuyxonj8CCToWKkk=";
  release."0.3.0".sha256 = "1ffr21dd6hy19gxnvcd4if2450iksvglvkd6q5713fajd72hmc0z";
  releaseRev = v: "v${v}";
  buildFlags = [ "NO_TEST=1" ];
  meta = {
    description = "Library to create Coq record update functions";
    maintainers = with lib.maintainers; [ ineol ];
  };
}
