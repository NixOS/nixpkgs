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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "kalshi_python";
    hash = "sha256-ybO7O+rxS3rSo6GN/FZC/BhSnlfH5/+TpJkSxhRBYYw=";
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
