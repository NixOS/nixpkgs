{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tack";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "tack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2wwH6pzL2vzffXKuMQwVMbUhfRubDwjPbrqdcbcJZqA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-xTSLcORGg6nUzi+1Th74+/egs/zKT4qmnemLUosCtXQ=";

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
