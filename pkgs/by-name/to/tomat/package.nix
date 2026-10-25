{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tomat";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "tomat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ysLRJqGSmqgADDquGWcqe2fJM9ZLvA6dJsXvLOGj1kY=";
  };

  cargoHash = "sha256-W7aE3X+pQ24hrMVfHSrvZh4t0cL1AZlb1SEHC9oM9D4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  checkFlags = [
    # Skip tests that require access to file system locations not available during Nix builds
    "--skip=timer::tests::test_icon_path_creation"
    "--skip=timer::tests::test_notification_icon_config"
    "--skip=integration::"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Apple's plutil is unavailable in the Nix build sandbox.
    "--skip=service::tests::launchd_service_is_a_valid_plist"
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
    changelog = "https://github.com/jolars/tomat/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jolars ];
    mainProgram = "tomat";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
