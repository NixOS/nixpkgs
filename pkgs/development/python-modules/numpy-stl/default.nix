{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytest-runner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.16.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e635b6fb6112a3c5e00e9e20eedab93b9b0c45ff1cc34eb7bdc0b3e922e2d77";
  };

  checkInputs = [ pytest pytest-runner ];

  checkPhase = "py.test";

  propagatedBuildInputs = [ cython numpy nine python-utils enum34 ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
  };
}
