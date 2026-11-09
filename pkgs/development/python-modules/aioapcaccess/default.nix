{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aioapcaccess";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuxincs";
    repo = "aioapcaccess";
    tag = "v${version}";
    hash = "sha256-gCi0vo4w3jr4w5neQS9v821rdfE+SqnUkrOrEQUET7E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioapcaccess" ];

  meta = {
    description = "Module for working with apcaccess";
    homepage = "https://github.com/yuxincs/aioapcaccess";
    changelog = "https://github.com/yuxincs/aioapcaccess/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
