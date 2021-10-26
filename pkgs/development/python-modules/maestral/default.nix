{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, click, desktop-notifier, dropbox, fasteners, keyring, keyrings-alt, packaging, pathspec, Pyro5, requests, setuptools, sdnotify, survey, watchdog
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "v${version}";
    sha256 = "sha256-R6zacpJkSWppodrb0SD4lglFmGVtPaloeDMBPL+ztuU=";
  };

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
    "--prefix" "PYTHONPATH" ":" "${lib.concatStringsSep ":" (map (p: p + "/lib/${python.libPrefix}/site-packages") (python.pkgs.requiredPythonModules propagatedBuildInputs))}"
    "--prefix" "PYTHONPATH" ":" "$out/lib/${python.libPrefix}/site-packages"
  ];

  checkInputs = [
    pytestCheckHook
  ];

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

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    homepage = "https://maestral.app";
  };
}
