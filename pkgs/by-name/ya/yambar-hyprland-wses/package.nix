{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "yambar-hyprland-wses";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "yambar-hyprland-wses";
    rev = "v${version}";
    hash = "sha256-furHj1AAFgNiNHP9RBsVrIvrDckSKU8FXilzH9TQ99c=";
  };

  cargoHash = "sha256-/ewEgrBxRw5Xii5PX1GLKzBrZjgnzYc/Hz+M1pJpncQ=";

  meta = {
    description = "Enable Yambar to show Hyprland workspaces";
    homepage = "https://github.com/jonhoo/yambar-hyprland-wses";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ludovicopiero ];
    mainProgram = "yambar-hyprland-wses";
    platforms = lib.platforms.linux;
  };
}
