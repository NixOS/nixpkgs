{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, blinker, bugsnag, click, dbus-next, dropbox, fasteners, keyring, keyrings-alt, pathspec, Pyro5, requests, sqlalchemy, u-msgpack-python, watchdog
, sdnotify
, systemd
}:

buildPythonPackage rec {
  pname = "maestral";
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral";
    rev = "v${version}";
    sha256 = "sha256-/xm6sGios5N68X94GqFFzH1jNSMK1OnvQiEykU9IAZU=";
  };

  propagatedBuildInputs = [
    blinker
    bugsnag
    click
    dbus-next
    dropbox
    fasteners
    keyring
    keyrings-alt
    pathspec
    Pyro5
    requests
    sqlalchemy
    u-msgpack-python
    watchdog
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    sdnotify
    systemd
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
