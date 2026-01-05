{
  lib,
  asyncssh,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "aioasuswrt";
    tag = "V${version}";
    hash = "sha256-tsvtOe3EX/Z7g6Z0MM2npYOTEJoKV9wUbhkhcROILxE=";
  };

  build-system = [ setuptools ];

  dependencies = [ asyncssh ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioasuswrt" ];

  meta = {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    changelog = "https://github.com/kennedyshead/aioasuswrt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
