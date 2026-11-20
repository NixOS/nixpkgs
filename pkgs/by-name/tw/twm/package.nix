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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twm";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = "twm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZJI1qFWmmZ0OJZN5qc7gpTGnhxrNAp3ZUsjqbWRPM+8=";
  };

  cargoHash = "sha256-VxVl/Ugcr56IrG+Y+R5PbdGsyHWdya+m/JgAK02CI2U=";

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
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "twm";
  };
})
