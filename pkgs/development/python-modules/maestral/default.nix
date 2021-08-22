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
  version = "1.4.8";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "v${version}";
    sha256 = "sha256-sxPogzQW+P8yrqaaJHrQu7e0ztgwWUI0kLikcmrhYoQ=";
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
