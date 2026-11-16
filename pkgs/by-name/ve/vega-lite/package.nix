{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  pixman,
  cairo,
  pango,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vega-lite";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vega-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bsPnvUleHrihsoOL98O8KTbiONx3FNuQjH9vrZ/bLTw=";
  };

  npmDepsHash = "sha256-dni2tEYzE/AzgGldCAtBpmQK24kIRck0KQXvD2e5xfw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    pixman
    pango
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/vega/vega-lite/releases/tag/v${finalAttrs.version}";
    description = "Concise grammar of interactive graphics, built on Vega";
    homepage = "https://vega.github.io/vega-lite/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
