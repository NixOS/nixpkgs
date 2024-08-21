{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyserial,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyserial-asyncio-fast";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "pyserial-asyncio-fast";
    rev = version;
    hash = "sha256-ZnXuwHvYq/BrEW6YV6T0sQ03u2rpwNBnpF+dXAmvxKQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  pythonImportsCheck = [ "serial_asyncio_fast" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/pyserial-asyncio-fast/releases/tag/${version}";
    description = "Fast asyncio extension package for pyserial that implements eager writes";
    homepage = "https://github.com/bdraco/pyserial-asyncio-fast";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
