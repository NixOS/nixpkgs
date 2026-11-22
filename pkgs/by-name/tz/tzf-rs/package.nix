{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tzf-rs";
  version = "2.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ringsaturn";
    repo = "tzf-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KVhsPN7zU5VbaLksA5nQpZxft7ZzCClkL9nRjgyblPg=";
  };

  buildFeatures = [
    # no method named `to_geojson` found for struct `DefaultFinder` in the current scope
    "export-geojson"
  ];

  cargoHash = "sha256-WBj9UkV9dejyxnaVAkJzAL+BWarKwMv0mdrHSw9XNys=";

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
