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
  version = "2.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95890627001efb2cb8d17418730cdc1bdd64b8dbb9862b01a8e0359d79fe863e";
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
