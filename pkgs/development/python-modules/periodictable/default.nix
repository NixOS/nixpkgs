{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,
  pyparsing,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "periodictable";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-periodictable";
    repo = "periodictable";
    tag = "v${version}";
    hash = "sha256-nI6hiLnqmVXT06pPkHCBEMTxZhfnZJqSImW3V9mJ4+8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pyparsing
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "periodictable" ];

  meta = {
    description = "Extensible periodic table of the elements";
    homepage = "https://github.com/pkienzle/periodictable";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
