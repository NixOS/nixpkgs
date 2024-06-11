{ lib, mkCoqDerivation, coq, ceres, coq-ext-lib, version ? null }:

mkCoqDerivation {

  pname = "parsec";
  repo = "coq-parsec";
  owner = "liyishuai";

  propagatedBuildInputs = [ ceres coq-ext-lib ];
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.14" "8.19"; out = "0.1.2"; }
    { case = range "8.12" "8.16"; out = "0.1.1"; }
    { case = range "8.12" "8.13"; out = "0.1.0"; }
  ] null;
  release."0.1.2".sha256 = "sha256-QN0h1CsX86DQBDsluXLtNUvMh3r60/0iDSbYam67AhA=";
  release."0.1.1".sha256 = "sha256:1c0l18s68pzd4c8i3jimh2yz0pqm4g38pca4bm7fr18r8xmqf189";
  release."0.1.0".sha256 = "sha256:01avfcqirz2b9wjzi9iywbhz9szybpnnj3672dgkfsimyg9jgnsr";

  meta = with lib; {
    description = "Library for serialization to S-expressions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
