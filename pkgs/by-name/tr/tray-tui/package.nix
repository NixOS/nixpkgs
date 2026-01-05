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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "tray-tui";
    tag = version;
    hash = "sha256-C/vF5dkY9eOL4RQTHuzi7F+mgHWOrVt6sv4eHqUNctg=";
  };

  cargoHash = "sha256-w5ZifkJ86OMiRdHE9f82pxlg7FBuoioD+hgI8CTJtmI=";

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
