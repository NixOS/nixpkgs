{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  urllib3,
  certifi,
  python-dateutil,
  six,
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
    urllib3
    certifi
    python-dateutil
    six
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
