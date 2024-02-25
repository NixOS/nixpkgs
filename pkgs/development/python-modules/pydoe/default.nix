{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, scipy
, numpy
}:

buildPythonPackage rec {
  pname = "pyDOE";
  version = "0.3.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "Design of experiments for Python";
    homepage = "https://github.com/tisimst/pyDOE";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
