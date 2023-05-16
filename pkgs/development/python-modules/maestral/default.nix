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
, pytestCheckHook
, nixosTests
}:

buildPythonPackage rec {
  pname = "maestral";
<<<<<<< HEAD
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YYbdd0GLVKE7+Oi0mpQjqhFdjdlquk/XnIg5WrtKcfI=";
=======
    hash = "sha256-XyyEAeEQEc7MhGyXBBLZDqzBL7K+0dMMCKhr0iENvog=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  ];

  makeWrapperArgs = [
    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath propagatedBuildInputs}"
    "--prefix PYTHONPATH : $out/lib/${python.libPrefix}/site-packages"
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
  ];

  pythonImportsCheck = [
    "maestral"
  ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    homepage = "https://maestral.app";
    changelog = "https://github.com/samschott/maestral/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg sfrijters ];
    platforms = platforms.unix;
  };
}
