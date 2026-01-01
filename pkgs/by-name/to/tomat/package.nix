{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  installShellFiles,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tomat";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "tomat";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-i6gakWbY6N1FB1lAfONuDsoXv5PcaXqnbmfuSBp/DC0=";
  };

  cargoHash = "sha256-dLdo0mtf9IO9mBc6MI1Q6fu8x6+TmlFN6rfEFC6cFek=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
=======
    hash = "sha256-xIIkyPcW/gIOS28efGR8ausBdnIj0/OkWLEM0MMTJLI=";
  };

  cargoHash = "sha256-Ij91tU31fPUapxwCjpP0ASw96OGs/D/RzmDA1pKmrgQ=";

  nativeBuildInputs = [
    pkg-config
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    alsa-lib
  ];

  checkFlags = [
    # Skip tests that require access to file system locations not available during Nix builds
    "--skip=timer::tests::test_icon_path_creation"
    "--skip=timer::tests::test_notification_icon_config"
    "--skip=integration::"
  ];

<<<<<<< HEAD
  postInstall = ''
    installShellCompletion --cmd tomat \
      --bash target/completions/tomat.bash \
      --fish target/completions/tomat.fish \
      --zsh target/completions/_tomat

    installManPage target/man/*
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Pomodoro timer for status bars";
    homepage = "https://github.com/jolars/tomat";
    changelog = "https://github.com/jolars/tomat/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jolars ];
    mainProgram = "tomat";
    platforms = lib.platforms.linux;
  };
}
