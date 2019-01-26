{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mh7p19rhx800dd54ij1pgln5ny03fdyvadyhrsb380fgjby2nh3";
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
