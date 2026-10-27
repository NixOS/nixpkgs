{
  lib,
  stdenvNoCC,
  dbus,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  samba,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termscp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = "termscp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rrb8ae+wpyHrRr4UHrUc7N+ytvI2OKmXmCWcnJOebJU=";
  };

  cargoHash = "sha256-Var5ZnwX9OyCh+G6/5JF1K/IJR7nQ5508+B1akfsito=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    samba
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  checkFeatures = [ "isolated-tests" ];

  checkFlags = [
    # Tests require networking
    "--skip=cli::remote::test::test_should_make_remote_args_from_one_bookmark_and_one_remote_with_local_dir"
    "--skip=cli::remote::test::test_should_make_remote_args_from_two_bookmarks_and_local_dir"
    "--skip=cli::remote::test::test_should_make_remote_args_from_two_remotes_and_local_dir"
    "--skip=system::auto_update::test::test_should_check_whether_github_api_is_reachable"
    "--skip=system::environment::tests::test_system_environment_get_config_dir_err"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI file transfer and explorer with support for SCP/SFTP/FTP/S3/SMB";
    changelog = "https://github.com/veeso/termscp/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/veeso/termscp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      gepbird
    ];
    mainProgram = "termscp";
    platforms = lib.platforms.linux;
  };
})
