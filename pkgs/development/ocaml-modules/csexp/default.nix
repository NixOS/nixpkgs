{
  lib,
  fetchurl,
  buildDunePackage,
  liquidsoap,
}:

buildDunePackage (finalAttrs: {
  pname = "csexp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${finalAttrs.version}/csexp-${finalAttrs.version}.tbz";
    hash = "sha256-GhTdBLtDeaQZkCSFUGKMd5E6nAfzw1wTcLaWDml3h/8=";
  };

  minimalOCamlVersion = "4.03";

  passthru.tests = {
    inherit liquidsoap;
  };

  meta = {
    description = "Minimal support for Canonical S-expressions";
    homepage = "https://github.com/ocaml-dune/csexp";
    changelog = "https://github.com/ocaml-dune/csexp/raw/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
