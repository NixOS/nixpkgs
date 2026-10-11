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
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vega-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fEnIqKdEysuP9GLmoOXItBJevxb5ZDxARW1qbqH2L2Y=";
  };

  npmDepsHash = "sha256-3oIMOqskhMOujN7aEKX6sVP6eEFtk5VrTnb8fKi9ja8=";

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
