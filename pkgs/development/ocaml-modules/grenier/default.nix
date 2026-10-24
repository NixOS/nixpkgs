{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "grenier";
  version = "0.17";
  src = fetchurl {
    url = "https://github.com/let-def/grenier/releases/download/v${finalAttrs.version}/grenier-${finalAttrs.version}.tbz";
    hash = "sha256-j312Ow0emwjIJEYQ0kH0t4FjdHW5tojQNRbjtSOd2d4=";
  };

  doCheck = true;

  meta = {
    description = "A collection of various algorithms in OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/let-def/grenier";
  };
})
