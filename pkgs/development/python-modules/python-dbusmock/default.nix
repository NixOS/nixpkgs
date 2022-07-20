{ lib
, buildPythonPackage
, fetchFromGitHub
, runtimeShell
, nose
, dbus
, dbus-python
, pygobject3
, which
, pyflakes
, pycodestyle
, bluez
, networkmanager
}:

buildPythonPackage rec {
  pname = "python-dbusmock";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-r4WAMj+ROrFHJ5kcZ32mArI9+tYakKgIcEgDcD0hTFo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'dbus-python' ""
  '';

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

  propagatedBuildInputs = [
    dbus-python
  ];

  checkInputs = [
    dbus
    pygobject3
    bluez
    (lib.getOutput "test" bluez)
    networkmanager
    nose
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
