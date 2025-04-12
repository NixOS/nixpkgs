{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "coinduction";
  owner = "damien-pous";
  inherit version;
  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.19" "8.19";
        out = "1.9";
      }
    ] null;
  release = {
    "1.9".sha256 = "sha256-bBU+xDklnzJBeN41GarW5KXzD8eKsOYtb//ULYumwWE=";
  };
  releaseRev = v: "v${v}";

  mlPlugin = true;

  meta = {
    description = "A library for doing proofs by (enhanced) coinduction";
    license = lib.licenses.lgpl3Plus;
  };
}
