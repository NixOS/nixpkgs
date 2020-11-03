{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0e019e575c61f2817526a20f96f10509834c696b67a54b2f1d267f7154b1ae7";
  };

  checkInputs = [ pytest pytestrunner ];

  checkPhase = "py.test";

  requiredPythonModules = [ cython numpy nine python-utils enum34 ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
  };
}
