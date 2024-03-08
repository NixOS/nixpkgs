{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, numpy
}:
let
  pname = "paddle-bfloat";
  version = "0.1.7";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    pname = "paddle_bfloat";
    inherit version;
    hash = "sha256-mrjQCtLsXOvqeHHMjuMx65FvMfZ2+wTh1ao9ZJE+9xw=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i bfloat16.cc # gcc12
    # replace deprecated function for python3.11
    substituteInPlace bfloat16.cc \
      --replace "Py_TYPE(&NPyBfloat16_Descr) = &PyArrayDescr_Type" "Py_SET_TYPE(&NPyBfloat16_Descr, &PyArrayDescr_Type)"
  '';

  disabled = pythonOlder "3.9" || pythonAtLeast "3.12";

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "paddle_bfloat" ];

# upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "Paddle numpy bfloat16 package";
    homepage = "https://pypi.org/project/paddle-bfloat";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
