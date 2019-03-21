{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r864sc7anw43s8bg5yd17bxcw1a4lj5h7mz7cbwnzpb9xmqpccj";
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
