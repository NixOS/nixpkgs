{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  six,
  numpy,
  scipy, # optional, allows spline-related features (see patsy's docs)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "0.5.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lcbUenIiU1+Ev/f2PXMD8uKXdHpZjbic9cZ/DAx9LNs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    six
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patsy" ];

  meta = {
    description = "Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
