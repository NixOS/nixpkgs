{
  lib,
  asyncssh,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-asyncio_0,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "aioasuswrt";
    tag = "V${version}";
    hash = "sha256-RQxIgAU9KsTbcTKc/Zl+aP77lbDSeiYzR48MtIVwacc=";
  };

  build-system = [ setuptools ];

  dependencies = [ asyncssh ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioasuswrt" ];

  meta = with lib; {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    changelog = "https://github.com/kennedyshead/aioasuswrt/releases/tag/V${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
