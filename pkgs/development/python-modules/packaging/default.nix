{ stdenv, buildPythonPackage, fetchPypi
, pyparsing, six, pytest, pretend }:

buildPythonPackage rec {
  pname = "packaging";
  version = "19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af";
  };

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [ pytest pretend ];

  checkPhase = ''
    py.test tests
  '';

  # Prevent circular dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Core utilities for Python packages";
    homepage = https://github.com/pypa/packaging;
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
