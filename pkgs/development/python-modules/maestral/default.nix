{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, click, desktop-notifier, dropbox, fasteners, keyring, keyrings-alt, packaging, pathspec, Pyro5, requests, setuptools, sdnotify, survey, watchdog
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.4.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "v${version}";
    sha256 = "sha256-kaRcM8Z0xeDp3JYputKZmzTfYYq2oKpF7AM6ciFF7I4=";
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

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    homepage = "https://maestral.app";
  };
}
