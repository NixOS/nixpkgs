{ lib
, buildPythonPackage
, fetchFromGitHub
, makePythonPath
, pythonOlder
, python
, click
, desktop-notifier
, dropbox
, fasteners
, keyring
, keyrings-alt
, packaging
, pathspec
, Pyro5
, requests
, setuptools
, sdnotify
, survey
, watchdog
, importlib-metadata
, pytestCheckHook
, nixosTests
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.6.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-JVzaWwdHAn5JOruLEN9Z2/5eV1oh3J2NQffNI3RqYfA=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
    click
    desktop-notifier
    dropbox
    fasteners
    keyring
    keyrings-alt
    packaging
    pathspec
    Pyro5
    requests
    setuptools
    sdnotify
    survey
    watchdog
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  makeWrapperArgs = [
    # Add the installed directories to the python path so the daemon can find them
    "--prefix PYTHONPATH : ${makePythonPath propagatedBuildInputs}"
    "--prefix PYTHONPATH : $out/lib/${python.libPrefix}/site-packages"
  ];

  checkInputs = [
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
  ];

  pythonImportsCheck = [ "maestral" ];

  passthru.tests.maestral = nixosTests.maestral;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg sfrijters ];
    platforms = platforms.unix;
    homepage = "https://maestral.app";
  };
}
