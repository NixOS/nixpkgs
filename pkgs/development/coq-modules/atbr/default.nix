{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "atbr";
  inherit version;
  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.20" "8.20";
        out = "8.20.0";
      }
    ] null;
  release = {
    "8.20.0".sha256 = "sha256-Okhtq6Gnq4HA3tEZJvf8JBnmk3OKdm6hC1qINmoShmo=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ stdlib ];

  mlPlugin = true;

  meta = {
    description = "Coq library and tactic for deciding Kleene algebras";
    license = lib.licenses.lgpl3Plus;
  };
}
