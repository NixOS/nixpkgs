{ lib
, stdenv
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, substituteAll
, alsa-utils
, libnotify
, which
, jeepney
, loguru
, pytest
, dbus
, coreutils
}:

buildPythonPackage rec {
  pname = "notify-py";
  version = "0.3.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "ms7m";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n35adwsyhz304n4ifnsz6qzkymwhyqc8sg8d76qv5psv2xsnzlf";
  };

  patches = lib.optionals stdenv.isLinux [
    # hardcode paths to aplay and notify-send
    (substituteAll {
      src = ./linux-paths.patch;
      aplay = "${alsa-utils}/bin/aplay";
      notifysend = "${libnotify}/bin/notify-send";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # hardcode path to which
    (substituteAll {
      src = ./darwin-paths.patch;
      which = "${which}/bin/which";
    })
  ];

  propagatedBuildInputs = [
    loguru
  ] ++ lib.optionals stdenv.isLinux [
    jeepney
  ];

  checkInputs = [
    pytest
  ] ++ lib.optionals stdenv.isLinux [
    dbus
  ];

  checkPhase = if stdenv.isDarwin then ''
    # Tests search for "afplay" binary which is built in to macOS and not available in nixpkgs
    mkdir $TMP/bin
    ln -s ${coreutils}/bin/true $TMP/bin/afplay
    PATH="$TMP/bin:$PATH" pytest
  '' else if stdenv.isLinux then ''
    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      pytest
  '' else ''
    pytest
  '';

  pythonImportsCheck = [ "notifypy" ];

  meta = with lib; {
    description = "Cross-platform desktop notification library for Python";
    homepage = "https://github.com/ms7m/notify-py";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler dotlambda ];
  };
}
