{ lib
, buildPythonPackage
, cython
, enum34
, fetchPypi
, nine
, numpy
, pytestCheckHook
, python-utils
}:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NskgGS9EXdV/CRpjYpvdpaknTUdROjOsLvrRJzc5S3o=";
  };

  propagatedBuildInputs = [
    cython
    enum34
    nine
    numpy
    python-utils
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stl" ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
