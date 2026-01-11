{
  coq,
  mkCoqDerivation,
  lib,
  version ? null,
}:

let
  derivation = mkCoqDerivation {

    pname = "stdlib";
    repo = "stdlib";
    owner = "coq";
    opam-name = "coq-stdlib";

    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch coq.coq-version [
        (case (isLe "9.1") "9.0.0")
        # the < 9.0 above is artificial as stdlib was included in Coq before
      ] null;
    releaseRev = v: "V${v}";

    release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";

    configurePhase = ''
      echo no configuration
    '';
    buildPhase = ''
      echo building nothing
    '';
    installPhase = ''
      echo installing nothing
      touch $out
    '';

    meta = {
      description = "Compatibility metapackage for Coq Stdlib library after the Rocq renaming";
      license = lib.licenses.lgpl21Only;
    };
  };
in
# this is just a wrapper for rocqPackages.stdlib for Rocq >= 9.0
if coq.rocqPackages ? stdlib then
  coq.rocqPackages.stdlib.override {
    inherit version;
    inherit (coq.rocqPackages) rocq-core;
  }
else
  derivation
