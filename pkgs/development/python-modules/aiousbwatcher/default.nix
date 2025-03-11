{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asyncinotify,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiousbwatcher";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "aiousbwatcher";
    tag = "v${version}";
    hash = "sha256-M9MUaB3oHELHdtgaWri9nILnVQpF2FJvHrL68jXeOqg=";
  };

  build-system = [ setuptools ];

  dependencies = [ asyncinotify ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiousbwatcher" ];

  meta = {
    description = "Watch for USB devices to be plugged and unplugged";
    homepage = "https://github.com/Bluetooth-Devices/aiousbwatcher";
    changelog = "https://github.com/Bluetooth-Devices/aiousbwatcher/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
