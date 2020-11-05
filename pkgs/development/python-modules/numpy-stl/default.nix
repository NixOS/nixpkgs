{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10912d7749ab02b0ee2ee61fc04c38fa211fc9d00a9b73a7d1c2465c53c1abf5";
  };

  checkInputs = [ pytest pytestrunner ];

  checkPhase = "py.test";

  propagatedBuildInputs = [ cython numpy nine python-utils enum34 ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
  };
}
