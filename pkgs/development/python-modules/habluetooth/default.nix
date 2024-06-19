{
  lib,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  bluetooth-adapters,
  bluetooth-auto-recovery,
  bluetooth-data-tools,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "habluetooth";
  version = "2.8.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "habluetooth";
    rev = "refs/tags/v${version}";
    hash = "sha256-2QiV32gDaoIBLUv/a3YzosFl6+E/nm0WoSUcTx9ph8s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=habluetooth --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  dependencies = [
    async-interrupt
    bleak
    bleak-retry-connector
    bluetooth-adapters
    bluetooth-auto-recovery
    bluetooth-data-tools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "habluetooth" ];

  meta = with lib; {
    description = "Library for high availability Bluetooth";
    homepage = "https://github.com/Bluetooth-Devices/habluetooth";
    changelog = "https://github.com/Bluetooth-Devices/habluetooth/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
