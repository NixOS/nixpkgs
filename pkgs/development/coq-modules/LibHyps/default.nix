{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "LibHyps";
  owner = "Matafou";
  inherit version;
  defaultVersion = if (lib.versions.range "8.11" "8.19") coq.version then "2.0.4.1" else null;
  release = {
    "2.0.4.1".sha256 = "09p89701zhrfdmqlpxw3mziw8yylj1w1skb4b0xpbdwd1vsn4k3h";
  };

  configureScript = "./configure.sh";

  releaseRev = (v: "libhyps-${v}");

  meta = {
    description = "Hypotheses manipulation library";
    license = lib.licenses.mit;
  };
}
