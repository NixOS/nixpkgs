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
}:

buildPythonPackage rec {
  pname = "python-dbusmock";
  version = "0.28.3";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-LV94F2f0Ir2Ayzk2YLL76TqeUuC0f7e+bH3vC/xKgfU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"dbus-python"' ""
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
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
