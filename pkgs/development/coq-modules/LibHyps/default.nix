{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "LibHyps";
  owner = "Matafou";
  inherit version;
  defaultVersion = if (lib.versions.range "8.11" "8.20") coq.version then "2.0.8" else null;
  release = {
    "2.0.8".sha256 = "sha256-u8T7ZWfgYNFBsIPss0uUS0oBvdlwPp3t5yYIMjYzfLc=";
  };

  configureScript = "./configure.sh";

  releaseRev = (v: "libhyps-${v}");

  meta = {
    description = "Hypotheses manipulation library";
    license = lib.licenses.mit;
  };
}
