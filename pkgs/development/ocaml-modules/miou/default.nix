{
  lib,
  buildDunePackage,
  fetchurl,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "miou";
  version = "0.10.2";

  minimalOCamlVersion = "5.2";

  src = fetchurl {
    url = "https://github.com/robur-coop/miou/releases/download/v${finalAttrs.version}/miou-${finalAttrs.version}.tbz";
    hash = "sha256-hcRvdKF8rVEgrmt+GxUJ0m8RnGJsTewqBQCfjFe4FVg=";
  };

  buildInputs = [ dune-configurator ];

  meta = {
    description = "Composable concurrency primitives for OCaml";
    homepage = "https://github.com/robur-coop/miou";
    changelog = "https://github.com/robur-coop/miou/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
