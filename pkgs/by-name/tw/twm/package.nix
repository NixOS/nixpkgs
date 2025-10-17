{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = "twm";
    tag = "v${version}";
    hash = "sha256-Hta9IvPViZFEiR+RXRmlPRwIu10D9B5dbXzhflxzBhY=";
  };

  cargoHash = "sha256-buiU+umHqyZ/3YoW2+5QpmF9AGEuNUihro5PFuWFSH4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    openssl
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd twm \
      --bash <($out/bin/twm --print-bash-completion) \
      --zsh <($out/bin/twm --print-zsh-completion) \
      --fish <($out/bin/twm --print-fish-completion)

    $out/bin/twm --print-man > twm.1
    installManPage twm.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "twm";
  };
}
