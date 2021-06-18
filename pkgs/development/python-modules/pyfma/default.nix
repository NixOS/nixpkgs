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
  version = "0.1.4";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bc6bf57d960a5232b7a56bd38e9fe3dce0911016746029931044b66bdec46e9";
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
