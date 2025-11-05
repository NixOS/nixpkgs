{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  makePythonPath,
  pythonOlder,
  python,
  click,
  dbus-python,
  desktop-notifier,
  dropbox,
  fasteners,
  importlib-metadata,
  keyring,
  keyrings-alt,
  packaging,
  pathspec,
  pyro5,
  requests,
  rich,
  rubicon-objc,
  setuptools,
  survey,
  typing-extensions,
  watchdog,
  xattr,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.9.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    tag = "v${version}";
    hash = "sha256-mYFiQL4FumJWP2y1u5tIo1CZL027J8/EIYqJQde7G/c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    desktop-notifier
    dbus-python
    dropbox
    fasteners
    keyring
    keyrings-alt
    packaging
    pathspec
    pyro5
    requests
    rich
    setuptools
    survey
    typing-extensions
    watchdog
    xattr
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rubicon-objc ];

  makeWrapperArgs = [
    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath dependencies}"
    "--prefix PYTHONPATH : $out/${python.sitePackages}"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # ModuleNotFoundError: No module named '_watchdog_fsevents'
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # We don't want to benchmark
    "test_performance"
    # Requires systemd
    "test_autostart"
    # Requires network access
    "test_check_for_updates"
    # Tries to look at /usr
    "test_filestatus"
    "test_path_exists_case_insensitive"
    "test_cased_path_candidates"
    # AssertionError
    "test_locking_multiprocess"
    # OSError: [Errno 95] Operation not supported
    "test_move_preserves_xattrs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # maetral daemon does not start but worked in real environment
    "test_catching_non_ignored_events"
    "test_connection"
    "test_event_handler"
    "test_fs_ignore_tree_creation"
    "test_lifecycle"
    "test_notify_level"
    "test_notify_snooze"
    "test_receiving_events"
    "test_remote_exceptions"
    "test_start_already_running"
    "test_stop"
  ];

  pythonImportsCheck = [ "maestral" ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    mainProgram = "maestral";
    homepage = "https://maestral.app";
    changelog = "https://github.com/samschott/maestral/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      natsukium
      peterhoeg
      sfrijters
    ];
  };
}
