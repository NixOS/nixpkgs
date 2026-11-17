{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tealdeer";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "tealdeer-rs";
    repo = "tealdeer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/tkK/LP62UG7Z6GMpUX/15d64zzW4bIoDe32emw3crE=";
  };

  cargoHash = "sha256-Od/dx77FGafEr94yDpDWL4K2I0U/2FuQ1QFjgKiAozU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash completion/bash_tealdeer \
      --fish completion/fish_tealdeer \
      --zsh completion/zsh_tealdeer
  '';

  # Disable tests that require Internet access:
  checkFeatures = [ "ignore-online-tests" ];
  # tealdeer requires --test-threads=1
  dontUseCargoParallelTests = true;

  meta = {
    description = "Very fast implementation of tldr in Rust";
    homepage = "https://github.com/tealdeer-rs/tealdeer";
    changelog = "https://github.com/tealdeer-rs/tealdeer/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      davidak
      newam
      mfrw
      ryan4yin
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "tldr";
  };
})
