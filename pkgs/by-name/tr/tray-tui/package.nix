{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tray-tui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "tray-tui";
    tag = version;
    hash = "sha256-iJ3793D6/yT63s4akdFvWIpe+5wgjWv29cwB5deID60=";
  };

  cargoHash = "sha256-T5O37QuubTHp9a5iYrXN2Wrc+Xez+rGiAowcbSp33A4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tray-tui \
      --bash <($out/bin/tray-tui --completions bash) \
      --zsh <($out/bin/tray-tui --completions zsh) \
      --fish <($out/bin/tray-tui --completions fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System tray in your terminal";
    homepage = "https://github.com/Levizor/tray-tui";
    license = lib.licenses.mit;
    mainProgram = "tray-tui";
    maintainers = with lib.maintainers; [ Levizor ];
    platforms = lib.platforms.linux;
  };
}
