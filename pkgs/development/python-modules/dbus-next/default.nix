{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  dbus,
  pytest,
  pytest-asyncio,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "dbus-next";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altdesktop";
    repo = "python-dbus-next";
    tag = "v${version}";
    hash = "sha256-EKEQZFRUe+E65Z6DNCJFL5uCI5kbXrN7Tzd4O0X5Cqo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    dbus
    pytest
    pytest-asyncio
    pytest-timeout
  ];

  # Tests are flaky and upstream is no longer active
  doCheck = false;

  # test_peer_interface hits a timeout
  # test_tcp_connection_with_forwarding fails due to dbus
  # creating unix socket anyway on v1.14.4
  checkPhase = ''
    runHook preCheck
    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf \
      ${python.interpreter} -m pytest -sv \
      -k "not test_peer_interface and not test_tcp_connection_with_forwarding"
    runHook postCheck
  '';

  meta = with lib; {
    description = "Zero-dependency DBus library for Python with asyncio support";
    homepage = "https://github.com/altdesktop/python-dbus-next";
    changelog = "https://github.com/altdesktop/python-dbus-next/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
