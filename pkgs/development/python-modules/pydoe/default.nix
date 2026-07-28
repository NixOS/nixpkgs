{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  scipy,
  numpy,
}:

buildPythonPackage rec {
  pname = "pydoe";
  version = "0.3.8";
  pyproject = true;

  src = fetchPypi {
    pname = "pyDOE";
    inherit version;
    hash = "sha256-y9bxSuJtPJ9zYBMgX1PqEZGt1FZwM8Pud7fdNWVmxLY=";
    extension = "zip";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    scipy
    numpy
  ];

  pythonImportsCheck = [ "pyDOE" ];

  meta = {
    description = "Design of experiments for Python";
    homepage = "https://github.com/tisimst/pyDOE";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
