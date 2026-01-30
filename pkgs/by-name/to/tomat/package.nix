{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tomat";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "tomat";
    tag = "v${version}";
    hash = "sha256-8/AOnwCJFXScnyyg2CUhIxzcCOxeWyVlEpae9sWhhts=";
  };

  cargoHash = "sha256-gjeqmuzz6qdAasu1/0Gz8y+tKhJEZTu90aJabdDafsc=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
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

  postInstall = ''
    installShellCompletion --cmd tomat \
      --bash target/completions/tomat.bash \
      --fish target/completions/tomat.fish \
      --zsh target/completions/_tomat

    installManPage target/man/*
  '';

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
