{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tomat";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "tomat";
    tag = "v${version}";
    hash = "sha256-lkNBcTn7uXWifIVNoXmggPy+UjozL5YqVYorH9XAejo=";
  };

  cargoHash = "sha256-jBpZyNfsJKchJnKwWJQeVavj0Yog83QrCM8kOJFVugg=";

  nativeBuildInputs = [
    pkg-config
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
