{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hypothesis,
  mypy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "algebraic-data-types";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jspahrsummers";
    repo = "adt";
    rev = "v" + version;
    hash = "sha256-RHLI5rmFxklzG9dyYgYfSS/srCjcxNpzNcK/RPNJBPE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    mypy
  ];

  disabledTestPaths = [
    # AttributeError: module 'mypy.types' has no attribute 'TypeVarDef'
    "tests/test_mypy_plugin.py"
  ];

  pythonImportsCheck = [ "adt" ];

  meta = with lib; {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/jspahrsummers/adt";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
  };
}
