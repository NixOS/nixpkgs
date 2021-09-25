{ lib, mkCoqDerivation, coq, ceres, coq-ext-lib, version ? null }:

with lib;
mkCoqDerivation {

  pname = "parsec";
  repo = "coq-parsec";
  owner = "liyishuai";

  propagatedBuildInputs = [ ceres coq-ext-lib ];
  releaseRev = (v: "v${v}");

  inherit version;
  defaultVersion = if versions.isGe "8.12" coq.version then "0.1.0" else null;
  release."0.1.0".sha256 = "sha256:01avfcqirz2b9wjzi9iywbhz9szybpnnj3672dgkfsimyg9jgnsr";

  meta = {
    description = "Library for serialization to S-expressions";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
