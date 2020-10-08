{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, alembic, bugsnag, click, dropbox, fasteners, keyring, keyrings-alt, packaging, pathspec, Pyro5, requests, setuptools, sdnotify, sqlalchemy, watchdog
, dbus-next
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "v${version}";
    sha256 = "sha256-kh3FYBSVOU4ywrYl6ONEIbLbkSuZmexNJC9dB+JtUjM=";
  };

  propagatedBuildInputs = [
    alembic
    bugsnag
    click
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
    sqlalchemy
    watchdog
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    dbus-next
  ];

  makeWrapperArgs = [
    # Add the installed directories to the python path so the daemon can find them
    "--prefix" "PYTHONPATH" ":" "${stdenv.lib.concatStringsSep ":" (map (p: p + "/lib/${python.libPrefix}/site-packages") (python.pkgs.requiredPythonModules propagatedBuildInputs))}"
    "--prefix" "PYTHONPATH" ":" "$out/lib/${python.libPrefix}/site-packages"
  ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
