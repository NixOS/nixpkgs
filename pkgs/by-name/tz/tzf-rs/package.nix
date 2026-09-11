{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tzf-rs";
  version = "1.3.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ringsaturn";
    repo = "tzf-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YFDoNlBLeFqv2aGa4Wbd9CwDAz6FOd+8OjSksGzzzlI=";
  };

  buildFeatures = [
    # no method named `to_geojson` found for struct `DefaultFinder` in the current scope
    "export-geojson"
  ];

  cargoHash = "sha256-FehvfC5cvmTjMqUR0nTkcUDC/IK+e5S/snKMI9OBJaM=";

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
