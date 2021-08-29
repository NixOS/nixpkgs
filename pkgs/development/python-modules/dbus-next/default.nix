{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, dbus, dbus-python, pytest, pytestcov, pytest-asyncio, pytest-timeout
}:

buildPythonPackage rec {
  pname = "dbus-next";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "altdesktop";
    repo = "python-dbus-next";
    rev = "v${version}";
    sha256 = "0x78ghkci4las13gwbrm8fzg671lx1q2cn8h0f64ki8yag1myia1";
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

  meta = with lib; {
    homepage = "https://github.com/altdesktop/python-dbus-next";
    description = "A zero-dependency DBus library for Python with asyncio support";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
