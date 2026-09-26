{
  lib,
  buildDunePackage,
  fetchurl,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "miou";
  version = "0.10.0";

  minimalOCamlVersion = "5.2";

  src = fetchurl {
    url = "https://github.com/robur-coop/miou/releases/download/v${finalAttrs.version}/miou-${finalAttrs.version}.tbz";
    hash = "sha256-vxlUxvZqydMGs7T5SLGfWdLDJyE6+TDhnZ+8c/E0+hg=";
  };

  buildInputs = [ dune-configurator ];

  meta = {
    description = "Composable concurrency primitives for OCaml";
    homepage = "https://git.robur.coop/robur/miou";
    changelog = "https://git.robur.coop/robur/miou/src/tag/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
