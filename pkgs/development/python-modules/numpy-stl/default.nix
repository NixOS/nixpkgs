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
  version = "2.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G42ak4w4OAbE2RTe3STN03A43/rZqJBbB8rBm0TlOWU=";
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
