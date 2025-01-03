{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.24.0";
in
rustPlatform.buildRustPackage {
  pname = "tinty";
  inherit version;

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinty";
    tag = "v${version}";
    hash = "sha256-Yvwls9bh8YN8/jKC889soCSotLSBU9hJWz95szOdJ2k=";
  };

  cargoHash = "sha256-jSKhKcBcURjizUZlqZmL5UT19gvNzHinD4rMQ3jMgVw=";

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
