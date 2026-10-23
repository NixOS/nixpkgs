{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tealdeer";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tealdeer-rs";
    repo = "tealdeer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aDhSxjRETpSaN+Dd9Aa1E+uZUVCp65QWne7mqJA7E54=";
  };

  cargoHash = "sha256-4qtjurYWbGrjtCGsJyu1aMCvSVJ1aC5TEdGRYMe5tUU=";

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
