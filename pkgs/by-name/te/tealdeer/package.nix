{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "tealdeer-rs";
    repo = "tealdeer";
    rev = "v${version}";
    hash = "sha256-QxkFpcEFLn98LvGDQ/PEovzzHTfNiKFQfGaHl/w5aLQ=";
  };

  cargoHash = "sha256-45oFBZC8IRCybhnmZfwDsouFVsm2hgPQohem/1nsAxc=";

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

<<<<<<< HEAD
  meta = {
    description = "Very fast implementation of tldr in Rust";
    homepage = "https://github.com/tealdeer-rs/tealdeer";
    changelog = "https://github.com/tealdeer-rs/tealdeer/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Very fast implementation of tldr in Rust";
    homepage = "https://github.com/tealdeer-rs/tealdeer";
    changelog = "https://github.com/tealdeer-rs/tealdeer/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      davidak
      newam
      mfrw
      ryan4yin
    ];
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    mainProgram = "tldr";
  };
}
