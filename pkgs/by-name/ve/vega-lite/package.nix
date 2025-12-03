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
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vega-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X6O7ZehY3tS7dFBaKnBuDokCfG+zWmSDHl1d+ifyc/o=";
  };

  npmDepsHash = "sha256-YjZdh5R7hawgf8EAGlKEAkqchcFuN1j2yMJo9Ptnjyk=";

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
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
