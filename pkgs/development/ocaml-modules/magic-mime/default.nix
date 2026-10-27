{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "magic-mime";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-magic-mime/releases/download/v${finalAttrs.version}/magic-mime-${finalAttrs.version}.tbz";
    hash = "sha256-4CNNA2Jduh76xY5X44dnLXWl6aYh/0ms/g9gnADxOwg=";
  };

  minimalOCamlVersion = "4.03";

  meta = {
    description = "Convert file extensions to MIME types";
    homepage = "https://github.com/mirage/ocaml-magic-mime";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
