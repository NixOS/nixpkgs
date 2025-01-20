{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  cython,
  poetry-core,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-codspeed,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bluetooth-data-tools";
  version = "1.22.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-data-tools";
    tag = "v${version}";
    hash = "sha256-ygtpOKrvVaM2rWfzRdKj96Z229+6wPSCuZq3agx+/IY=";
  };

  # The project can build both an optimized cython version and an unoptimized
  # python version. This ensures we fail if we build the wrong one.
  env.REQUIRE_CYTHON = 1;

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    pytest-benchmark
    pytest-cov-stub
    pytest-codspeed
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "bluetooth_data_tools" ];

  meta = with lib; {
    description = "Library for converting bluetooth data and packets";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-data-tools";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-data-tools/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
