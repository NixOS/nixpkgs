{ lib
, buildPythonPackage
, fetchFromGitHub
, makePythonPath
, pythonOlder
, python
, click
, dbus-python
, desktop-notifier
, dropbox
, fasteners
, importlib-metadata
, keyring
, keyrings-alt
, packaging
, pathspec
, pyro5
, requests
, rich
, setuptools
, survey
, typing-extensions
, watchdog
, xattr
, pytestCheckHook
, nixosTests
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "refs/tags/v${version}";
    hash = "sha256-h7RDaCVICi3wl6/b1s01cINhFirDOpOXoxTPZIBH3jE=";
  };

  propagatedBuildInputs = [
    click
    desktop-notifier
    dbus-python
    dropbox
    fasteners
    importlib-metadata
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
  ];

  makeWrapperArgs = [
    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath propagatedBuildInputs}"
    "--prefix PYTHONPATH : $out/${python.sitePackages}"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
  ];

  pythonImportsCheck = [
    "maestral"
  ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    mainProgram = "maestral";
    homepage = "https://maestral.app";
    changelog = "https://github.com/samschott/maestral/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg sfrijters ];
    platforms = platforms.unix;
  };
}
