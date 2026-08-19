{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tray-tui";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "tray-tui";
    tag = finalAttrs.version;
    hash = "sha256-P34tL65vTxqDfc3syOlSw+E/bMaQXNF4gen9rZDWLxg=";
  };

  cargoHash = "sha256-oRY2K3F8cvzqfxgBDGhX2WrroGcV+hLKbYKFvrfKUuk=";

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
})
