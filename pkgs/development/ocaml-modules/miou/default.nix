{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "miou";
  version = "0.1.0";

  minimalOCamlVersion = "5.0.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/miou/releases/download/v${version}/miou-${version}.tbz";
    hash = "sha256-WTs6L9j4z1/0wKcGIZVwaNrATRGCTN5A6RwO7tY2phE=";
  };

  meta = {
    description = "Composable concurrency primitives for OCaml";
    homepage = "https://git.robur.coop/robur/miou";
    changelog = "https://git.robur.coop/robur/miou/src/tag/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
