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

  meta = with lib; {
    description = "Enable Yambar to show Hyprland workspaces";
    homepage = "https://github.com/jonhoo/yambar-hyprland-wses";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ ludovicopiero ];
    mainProgram = "yambar-hyprland-wses";
    platforms = platforms.linux;
  };
}
