{ lib, mkCoqDerivation, coq, version ? null }:

with lib;

mkCoqDerivation {
  pname = "coqtail-math";
  owner = "coq-community";
  inherit version;
  defaultVersion = if versions.range "8.11" "8.13" coq.coq-version then "20201124" else null;
  release."20201124".rev    = "5c22c3d7dcd8cf4c47cf84a281780f5915488e9e";
  release."20201124".sha256 = "sha256-wd+Lh7dpAD4zfpyKuztDmSFEZo5ZiFrR8ti2jUCVvoQ=";

  extraNativeBuildInputs = with coq.ocamlPackages; [ ocaml findlib ];

  meta = {
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.siraben ];
  };
}
