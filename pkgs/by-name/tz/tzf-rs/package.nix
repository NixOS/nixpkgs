{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tzf-rs";
  version = "1.3.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ringsaturn";
    repo = "tzf-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rvnykaYvQ992ehVwVds9UtTH9b4iydxac1JtNfKmYv0=";
  };

  buildFeatures = [
    # no method named `to_geojson` found for struct `DefaultFinder` in the current scope
    "export-geojson"
  ];

  cargoHash = "sha256-Pm/89K4RKdjxT/LKfJzYlhTOqz40sXo8PMj7q1FHj3M=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast timezone finder for Rust";
    homepage = "https://github.com/ringsaturn/tzf-rs";
    changelog = "https://github.com/ringsaturn/tzf-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "tzf";
    platforms = lib.platforms.unix;
  };
})
