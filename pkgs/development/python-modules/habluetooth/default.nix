{ lib
, bleak
, bleak-retry-connector
, bluetooth-adapters
, bluetooth-auto-recovery
, bluetooth-data-tools
, buildPythonPackage
, cython
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "habluetooth";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "habluetooth";
    rev = "refs/tags/v${version}";
    hash = "sha256-oPdKmaj2wKgOQw7QYwOQc8efcNtQiGryZgNJ+bbB6L8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=habluetooth --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    bluetooth-adapters
    bluetooth-auto-recovery
    bluetooth-data-tools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "habluetooth"
  ];

  meta = with lib; {
    description = "Library for high availability Bluetooth";
    homepage = "https://github.com/Bluetooth-Devices/habluetooth";
    changelog = "https://github.com/Bluetooth-Devices/habluetooth/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
