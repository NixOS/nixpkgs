{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tack";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "tack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhJb0NWLhj8AkD8uWEbXt179YlFLemk0OgOltw4jEk8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-3vDMM5uTsmRso6McH/b3+RpjeKjhgQm9V1piBrnSRjk=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/tack";
    description = "flake-like toml nix pins, lazily fetched and transformed";
    mainProgram = "tack";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      amaanq
      atagen
      faukah
      max
      NotAShelf
    ];
  };
})
