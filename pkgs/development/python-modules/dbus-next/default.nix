{ stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, dbus, dbus-python, pytest, pytestcov, pytest-asyncio, pytest-timeout
}:

buildPythonPackage rec {
  pname = "dbus-next";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "altdesktop";
    repo = "python-dbus-next";
    rev = "v${version}";
    sha256 = "sha256-C/aFDHmt6Qws6ek+++wM5GRN6TEvMGMiFktKIXRdGL0=";
  };

  checkInputs = [
    dbus
    dbus-python
    pytest
    pytestcov
    pytest-asyncio
    pytest-timeout
  ];

  # test_peer_interface hits a timeout
  checkPhase = ''
    dbus-run-session --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ${python.interpreter} -m pytest -sv --cov=dbus_next \
      -k "not test_peer_interface"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/altdesktop/python-dbus-next";
    description = "A zero-dependency DBus library for Python with asyncio support";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
