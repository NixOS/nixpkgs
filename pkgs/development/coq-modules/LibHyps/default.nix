{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "LibHyps";
  owner = "Matafou";
  inherit version;
<<<<<<< HEAD
  defaultVersion = if (lib.versions.range "8.11" "8.18") coq.version then "2.0.4.1" else null;
=======
  defaultVersion = if (lib.versions.range "8.11" "8.17") coq.version then "2.0.4.1" else null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
