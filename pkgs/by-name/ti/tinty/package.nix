{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.32.2";
in
rustPlatform.buildRustPackage {
  pname = "tinty";
  inherit version;

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinty";
    tag = "v${version}";
    hash = "sha256-+13iS99bwvIZDy96x1fgOtDyvbu59ieY4nUZk91mK4s=";
  };

  cargoHash = "sha256-gShC4+uzdJVi3KuLc6ImJRvEWvIY4vgKcYT8Aykm0Xc=";

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
    maintainers = with lib.maintainers; [
      pluiedev
      cohei
    ];
    mainProgram = "tinty";
  };
}
