{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  name = "${pname}-${version}";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33e88013ed2f4f9ec45598f0e0930a0d602ab3c49aa19e92703a867f37ffe520";
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
