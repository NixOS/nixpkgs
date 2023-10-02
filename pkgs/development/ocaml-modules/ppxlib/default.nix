{ lib, fetchurl, buildDunePackage, ocaml
, version ?
  if lib.versionAtLeast ocaml.version "4.07"
  then if lib.versionAtLeast ocaml.version "4.08"
  then if lib.versionAtLeast ocaml.version "4.11"
  then "0.30.0" else "0.24.0" else "0.15.0" else "0.13.0"
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
, stdlib-shims, ocaml-migrate-parsetree-2
}:

let param = {
  "0.8.1" = {
    sha256 = "sha256-pct57oO7qAMEtlvEfymFOCvviWaLG0b5/7NzTC8vdSE=";
    max_version = "4.10";
    useDune2 = false;
    OMP = [ ocaml-migrate-parsetree ];
  };
  "0.13.0" = {
    sha256 = "sha256-geHz0whQDg5/YQjVsN2iuHlkClwh7z3Eqb2QOBzuOdk=";
    max_version = "4.11";
    useDune2 = false;
    OMP = [ ocaml-migrate-parsetree ];
  };
  "0.15.0" = {
    sha256 = "sha256-C2MNf410qJmlXMJxiLXOA+c1qT8H6gwt5WUy2P2TszA=";
    min_version = "4.07";
    max_version = "4.12";
    OMP = [ ocaml-migrate-parsetree ];
  };
  "0.18.0" = {
    sha256 = "sha256-nUg8NkZ64GHHDfcWbtFGXq3MNEKu+nYPtcVDm/gEfcM=";
    min_version = "4.07";
    max_version = "4.12";
    OMP = [ ocaml-migrate-parsetree-2 ];
  };
  "0.22.0" = {
    sha256 = "sha256-PuuR4DlmZiKEoyIuYS3uf0+it2N8U9lXLSp0E0u5bXo=";
    min_version = "4.07";
    max_version = "4.13";
    OMP = [ ocaml-migrate-parsetree-2 ];
  };
  "0.22.2" = {
    sha256 = "sha256-0Oih69xiILFXTXqSbwCEYMURjM73m/mgzgJC80z/Ilo=";
    min_version = "4.07";
    max_version = "4.14";
    OMP = [ ocaml-migrate-parsetree-2 ];
  };
  "0.23.0" = {
    sha256 = "sha256-G1g2wYa51aFqz0falPOWj08ItRm3cpzYao/TmXH+EuU=";
    min_version = "4.07";
    max_version = "4.14";
  };
  "0.24.0" = {
    sha256 = "sha256-d2YCfC7ND1s7Rg6SEqcHCcZ0QngRPrkfMXxWxB56kMg=";
    min_version = "4.07";
    max_version = "5.1";
  };
  "0.28.0" = {
    sha256 = "sha256-2Hrl+aCBIGMIypZICbUKZq646D0lSAHouWdUSLYM83c=";
    min_version = "4.07";
    max_version = "5.1";
  };
  "0.30.0" = {
    sha256 = "sha256-3UpjvenSm0mBDgTXZTk3yTLxd6lByg4ZgratU6xEIRA=";
    min_version = "4.07";
  };
}."${version}"; in

if param ? max_version && lib.versionAtLeast ocaml.version param.max_version
|| param ? min_version && lib.versionOlder ocaml.version param.min_version
then throw "ppxlib-${version} is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "ppxlib";
  inherit version;

  duneVersion = if param.useDune2 or true then "3" else "1";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppxlib/releases/download/${version}/ppxlib-${version}.tbz";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs
  ] ++ (param.OMP or []) ++ [
    ppx_derivers
    stdio
    stdlib-shims
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml-ppx/ppxlib";
  };
}
