{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, dbus
, dbus-python
, pygobject3
, bluez
, networkmanager
, setuptools-scm
, runCommand
}:

let
  # Cannot just add it to path in preCheck since that attribute will be passed to
  # mkDerivation even with doCheck = false, causing a dependency cycle.
  pbap-client = runCommand "pbap-client" { } ''
    mkdir -p "$out/bin"
    ln -s "${bluez.test}/test/pbap-client" "$out/bin/pbap-client"
  '';
in buildPythonPackage rec {
  pname = "python-dbusmock";
  version = "0.29.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sfvVLPTSTXjwyB0a2NyDIONv01FXZ40nHZwwo3oqI90=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dbus-python
  ];

  nativeCheckInputs = [
    dbus
    pygobject3
    bluez
    pbap-client
    networkmanager
    nose
  ];

  # TODO: Get the rest of these tests running?
  NOSE_EXCLUDE = lib.concatStringsSep "," [
    "test_bluez4" # NixOS ships BlueZ5
    # These appear to fail because they're expecting to run in an Ubuntu chroot?
    "test_everything" # BlueZ5 OBEX
    "test_polkitd"
    "test_consolekit"
    "test_api"
    "test_logind"
    "test_notification_daemon"
    "test_ofono"
    "test_gnome_screensaver"
    "test_cli"
    "test_timedated"
    "test_upower"
    # needs glib
    "test_accounts_service"
    # needs dbus-daemon active
    "test_systemd"
    # Very slow, consider disabling?
    # "test_networkmanager"
  ];

  checkPhase = ''
    runHook preCheck
    nosetests -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "Mock D-Bus objects for tests";
    homepage = "https://github.com/martinpitt/python-dbusmock";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
