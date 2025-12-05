{
  lib,
  async-timeout,
  buildPythonPackage,
  cython,
  dbus,
  fetchFromGitHub,
  poetry-core,
  pytest,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dbus-fast";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "dbus-fast";
    tag = "v${version}";
    hash = "sha256-WmVtJ/hTFTohsbxwXpBbOvDE8/pdPHX2rBurxtW+ct0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3,<3.3.0" Cython
  '';

  # The project can build both an optimized cython version and an unoptimized
  # python version. This ensures we fail if we build the wrong one.
  env.REQUIRE_CYTHON = 1;

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ async-timeout ];

  nativeCheckInputs = [
    dbus
    pytest
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "dbus_fast"
    "dbus_fast.aio"
    "dbus_fast.service"
    "dbus_fast.message"
  ];

  checkPhase = ''
    runHook preCheck

    # test_peer_interface times out
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      ${python.interpreter} -m pytest -k "not test_peer_interface"

    runHook postCheck
  '';

  meta = with lib; {
    description = "Faster version of dbus-next";
    homepage = "https://github.com/bluetooth-devices/dbus-fast";
    changelog = "https://github.com/Bluetooth-Devices/dbus-fast/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
