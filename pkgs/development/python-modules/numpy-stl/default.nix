{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f57fdb3c0e420f729dbe54ec3add9bdbbd19b62183aa8f4576e00e5834b2ef52";
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
