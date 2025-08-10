{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

with lib;
let
  derivation = mkCoqDerivation {
    pname = "parseque";
    repo = "parseque";
    owner = "rocq-community";

    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with versions;
      switch coq.coq-version [
        (case (range "8.16" "8.20") "0.2.2")
      ] null;

    release."0.2.2".sha256 = "sha256-O50Rs7Yf1H4wgwb7ltRxW+7IF0b04zpfs+mR83rxT+E=";

    releaseRev = v: "v${v}";

    meta = {
      description = "Total parser combinators in Coq/Rocq";
      maintainers = with maintainers; [ womeier ];
      license = licenses.mit;
    };
  };
in
# this is just a wrapper for rocqPackages.parseque for Rocq >= 9.0
if coq.rocqPackages ? parseque then
  coq.rocqPackages.parseque.override {
    inherit version;
    inherit (coq.rocqPackages) rocq-core;
  }
else
  derivation
