{
  lib,
  buildDunePackage,
  fetchurl,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "miou";
  version = "0.6.0";

  minimalOCamlVersion = "5.0.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/miou/releases/download/v${finalAttrs.version}/miou-${finalAttrs.version}.tbz";
    hash = "sha256-EKJYAdRvg2ZAlTMzlOeuw3ReSU8NY074Asn8+CbKfpw=";
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
