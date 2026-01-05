{
  lib,
  mkCoqDerivation,
  coq,
  ceres,
  ExtLib,
  version ? null,
}:

mkCoqDerivation {

  pname = "parsec";
  repo = "coq-parsec";
  owner = "liyishuai";

  propagatedBuildInputs = [
    ceres
    ExtLib
  ];
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.version [
      (case (range "8.14" "9.1") "0.2.0")
      (case (range "8.14" "8.20") "0.1.2")
      (case (range "8.12" "8.16") "0.1.1")
      (case (range "8.12" "8.13") "0.1.0")
    ] null;
  release."0.2.0".sha256 = "sha256-hM6LVFQ2VQ42QeHu8Ex+oz1VvJUr+g8/nZN+bYHEljQ=";
  release."0.1.2".sha256 = "sha256-QN0h1CsX86DQBDsluXLtNUvMh3r60/0iDSbYam67AhA=";
  release."0.1.1".sha256 = "sha256:1c0l18s68pzd4c8i3jimh2yz0pqm4g38pca4bm7fr18r8xmqf189";
  release."0.1.0".sha256 = "sha256:01avfcqirz2b9wjzi9iywbhz9szybpnnj3672dgkfsimyg9jgnsr";

  useDuneifVersion = v: lib.versions.isGe "0.2.0" v || v == "dev";

  meta = with lib; {
    description = "Library for serialization to S-expressions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
