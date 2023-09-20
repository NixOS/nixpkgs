{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "coqtail-math";
  owner = "coq-community";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.11" "8.15"; out = "8.14"; }
    { case = range "8.11" "8.13"; out = "20201124"; }
  ] null;

  release."8.14".sha256 = "sha256:1k8f8idjnx0mf4z479vcx55iz42rjxrbplbznv80m2famxakq03c";
  release."20201124".rev    = "5c22c3d7dcd8cf4c47cf84a281780f5915488e9e";
  release."20201124".sha256 = "sha256-wd+Lh7dpAD4zfpyKuztDmSFEZo5ZiFrR8ti2jUCVvoQ=";
  mlPlugin = true;
  meta = with lib; {
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.siraben ];
  };
}
