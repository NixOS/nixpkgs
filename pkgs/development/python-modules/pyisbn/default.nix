{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hypothesis,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "pyisbn";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cPVjgXlps/8IUGieULx/917puGXD+A+DWWSxMGxO1Rk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pyisbn" ];

  meta = {
    description = "Python module for working with 10- and 13-digit ISBNs";
    homepage = "https://github.com/JNRowe/pyisbn";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eigengrau ];
  };
}
