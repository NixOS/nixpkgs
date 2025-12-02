{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "waterproof";
  owner = "impermeable";
  repo = "coq-waterproof";
  inherit version;
  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.18" "8.18";
        out = "2.1.1+8.18";
      }
    ] null;
  release = {
    "2.1.1+8.18".sha256 = "sha256-jYuQ9SPFRefNCUfn6+jEaJ4399EnU0gXPPkEDCpJYOI=";
  };

  propagatedBuildInputs = [ stdlib ];

  mlPlugin = true;

  useDune = true;

  meta = {
    description = "Coq proofs in a style that resembles non-mechanized mathematical proofs";
    license = lib.licenses.lgpl3Plus;
  };
}
