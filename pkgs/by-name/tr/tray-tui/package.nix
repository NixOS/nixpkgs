{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tray-tui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "tray-tui";
    tag = version;
    hash = "sha256-yCA0qN51xrfhHOL34prn6T4qZ7PsLHX1l2yd4o6oGCo=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-m6m9zZ/H1FpEDTh1M94ZwxLht1Of13xNqM7T3igjc6M=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
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
