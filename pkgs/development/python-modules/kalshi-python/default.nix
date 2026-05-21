{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  certifi,
  cryptography,
  lazy-imports,
  pydantic,
  python-dateutil,
  six,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "kalshi-python";
  version = "2.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "kalshi_python";
    hash = "sha256-FsHRuqfmdF31l5E/L08/eVhWkN7JhgJkFSUzMrYNuOY=";
  };

  dependencies = [
    certifi
    cryptography
    lazy-imports
    pydantic
    python-dateutil
    six
    typing-extensions
    urllib3
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kalshi_python"
  ];

  meta = {
    description = "Official python SDK for algorithmic trading on Kalshi";
    homepage = "https://github.com/Kalshi/kalshi-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ robbiebuxton ];
  };
}
