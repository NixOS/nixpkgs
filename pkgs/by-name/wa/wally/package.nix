{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wally";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "UpliftGames";
    repo = "wally";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbEUj6iWwm3KtfUwNkJf8cSjXMQ4Mki/jAqQavDajUA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # https://github.com/UpliftGames/wally/issues/223
  cargoPatches = [ ./Cargo.lock.patch ];
  cargoHash = "sha256-5Lfs5GlOPxvltFpbgPBhStWxPGqv8nYpY/WC2ABtea0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern package manager for Roblox projects inspired by Cargo";
    homepage = "https://github.com/UpliftGames/wally";
    downloadPage = "https://github.com/UpliftGames/wally/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/UpliftGames/wally/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ anninzy ];
    mainProgram = "wally";
    badPlatforms = lib.platforms.darwin;
  };
})
