{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.29.0";
in
rustPlatform.buildRustPackage {
  pname = "tinty";
  inherit version;

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinty";
    tag = "v${version}";
    hash = "sha256-p05fRJR0boNKGAZ7+KGPyY3XUmj20QfZteWr80cA/po=";
  };

  cargoHash = "sha256-Mdfz412Y1kb4V6LXOHxrbP3WsnWiZ+irCO5Qi3DRQ4c=";

  # Pretty much all tests require internet access
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Base16 and base24 color scheme manager";
    homepage = "https://github.com/tinted-theming/tinty";
    changelog = "https://github.com/tinted-theming/tinty/blob/refs/tags/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "tinty";
  };
}
