{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
}:

buildDunePackage (finalAttrs: {
  pname = "grenier";
  version = "0.17";
  src = fetchurl {
    url = "https://github.com/let-def/grenier/releases/download/v${finalAttrs.version}/grenier-${finalAttrs.version}.tbz";
    hash = "sha256-rc5Uf66bVkjZAtkRc7t4dGahl/gWELdnV0JKszmA5iU=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.11";

  meta = {
    description = "A collection of various algorithms in OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/let-def/grenier";
  };
})
