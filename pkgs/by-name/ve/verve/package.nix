{
  lib,
  rustPlatform,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  cargo-tauri_1,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verve";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "parthjadhav";
    repo = "verve";
    tag = finalAttrs.version;
    hash = "sha256-u5rGIBpq+DWE+XcPmvfZUfJ/V0sSUm8bHjMLfVhRRiA=";
  };

  cargoHash = "sha256-Yxt6oSG91y8GOInsP98FXGssop63vo0SIxisdq76Uzo=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-bFTIsQGlYN53/Wnqh5yuFIqAe1XXvNp+Q4BxgoZUvpg=";
  };

  nativeBuildInputs = [
    nodejs
    cargo-tauri_1.hook
    yarnConfigHook
    yarnBuildHook
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Open-Source Launcher alternative to Raycast";
    homepage = "https://github.com/ParthJadhav/Verve";
    changelog = "https://github.com/ParthJadhav/Verve/releases/tag/${finalAttrs.version}";

    license = lib.licenses.agpl3Only;
    mainProgram = "verve";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
