{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytest-runner, python-utils, enum34 }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "411c633d2a03c295d98fb26023a6e7f574ceead04015d06e80cdab20b630a742";
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
