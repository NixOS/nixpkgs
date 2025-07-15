{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tray-tui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Levizor";
    repo = "tray-tui";
    tag = version;
    hash = "sha256-iZyhcBCOUq2KuQR21sQiwFeEIr7DNBs1fYRu5Nv5+ng=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-o3FmSNOiCcbLoU6/LtbugalWUm/ME9kG8bzfem3HqWI=";

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
