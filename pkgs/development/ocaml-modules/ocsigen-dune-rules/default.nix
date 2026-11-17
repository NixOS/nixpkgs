{
  lib,
  fetchurl,
  buildDunePackage,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsigen-dune-rules";
  version = "1.0.0";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/ocsigen/ocsigen-dune-rules/releases/download/${finalAttrs.version}/ocsigen-dune-rules-${finalAttrs.version}.tbz";
    hash = "sha256-WxyHYSIESGHeqSOeut3X14kRFd2jz1o34qtBe9bI3bo=";
  };

  buildInputs = [ cmdliner ];

  meta = {
    license = lib.licenses.mit;
    description = "Generate Dune rules for building a client/server application or library";
    homepage = "https://github.com/ocsigen/ocsigen-dune-rules/";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
