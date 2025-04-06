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

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = "termscp";
    tag = "v${version}";
    hash = "sha256-ClCPXux1sM3hRbtJ3YngrAmc4btTgQmg/Bg/7uFHCOw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k/6+EWHAXd8BN551xDlQkYsBZsP/jgT+NO5GbVXJkVI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    samba
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  checkFeatures = [ "isolated-tests" ];
  checkFlags =
    [
      # requires networking
      "--skip=cli::remote::test::test_should_make_remote_args_from_one_bookmark_and_one_remote_with_local_dir"
      "--skip=cli::remote::test::test_should_make_remote_args_from_two_bookmarks_and_local_dir"
      "--skip=cli::remote::test::test_should_make_remote_args_from_two_remotes_and_local_dir"
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
      "--skip=system::watcher::test::should_poll_file_removed"
      "--skip=system::watcher::test::should_poll_file_update"
      "--skip=system::watcher::test::should_poll_nothing"
    ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/veeso/termscp/blob/v${version}/CHANGELOG.md";
    description = "Feature rich terminal UI file transfer and explorer with support for SCP/SFTP/FTP/S3/SMB";
    homepage = "https://github.com/veeso/termscp";
    license = lib.licenses.mit;
    mainProgram = "termscp";
    maintainers = with lib.maintainers; [
      fab
      gepbird
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
