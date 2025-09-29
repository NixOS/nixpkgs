{
  lib,
  asyncssh,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-asyncio_0,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "aioasuswrt";
    tag = "v${version}";
    hash = "sha256-Dipyl9njf3EH6ugm3+jrNulqJ5cMnmihOwSZHkqdueg=";
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
    changelog = "https://github.com/kennedyshead/aioasuswrt/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
