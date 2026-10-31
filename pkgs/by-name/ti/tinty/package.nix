{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.35.0";
in
rustPlatform.buildRustPackage {
  pname = "tinty";
  inherit version;

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinty";
    tag = "v${version}";
    hash = "sha256-5K3U3FaE9naZTGQ7GuLddQwyjNCIAW/xPgt1Ym7H+IE=";
  };

  cargoHash = "sha256-6Lkesm1qwNlMeAxErJqdYAgyOK3wRTvMHNxIGk8+91Q=";

  # Pretty much all tests require internet access
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Base16 and base24 color scheme manager";
    homepage = "https://github.com/tinted-theming/tinty";
    changelog = "https://github.com/tinted-theming/tinty/blob/refs/tags/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pluiedev
      cohei
    ];
    mainProgram = "tinty";
  };
}
