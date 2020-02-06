{ lib, buildPythonPackage, fetchFromGitHub, runtimeShell,
  nose, dbus, dbus-python, pygobject3,
  which, pyflakes, pycodestyle, bluez, networkmanager
}:

buildPythonPackage rec {
  pname = "python-dbusmock";
  version = "0.19";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = version;
    sha256 = "09j338lmrjabbd3fpajr4piz4r20sl33030szfsqfzlwrrmvkyi0";
  };

  prePatch = ''
    substituteInPlace tests/test_code.py \
      --replace "pyflakes3" "pyflakes" \
      --replace "/bin/bash" "${runtimeShell}" \
      --replace "--ignore=E124,E402,E731,W504" "--ignore=E124,E402,E731,W504,E501" # ignore long lines too
  '';

  # TODO: Get the rest of these tests running?
  # This is a mocking library used as a check dependency for a single derivation.
  # That derivation's tests pass. Maybe not worth the effort to fix these...
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
    # Very slow, consider disabling?
    # "test_networkmanager"
  ];

  checkInputs = [
    nose dbus dbus-python which pycodestyle pyflakes
    pygobject3 bluez bluez.test networkmanager
  ];

  checkPhase = ''
    runHook preCheck
    export PATH="$PATH:${bluez.test}/test";
    nosetests -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "Mock D-Bus objects for tests";
    homepage = https://github.com/martinpitt/python-dbusmock;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
