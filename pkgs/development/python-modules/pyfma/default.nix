{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, pybind11
, exdown
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a9e2503fd01baa4978af5f491b79b7646d7872df9ecc7ab63ba10c250c50d8a";
  };

  buildInputs = [
    pybind11
  ];

  checkInputs = [
    exdown
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfma" ];

  meta = with lib; {
    description = "Fused multiply-add for Python";
    homepage = "https://github.com/nschloe/pyfma";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc];
  };
}
