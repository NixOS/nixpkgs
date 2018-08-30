{ stdenv, buildPythonPackage, fetchPypi
, pyparsing, six, pytest, pretend }:

buildPythonPackage rec {
  pname = "packaging";
  version = "17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b";
  };

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [ pytest pretend ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Core utilities for Python packages";
    homepage = https://github.com/pypa/packaging;
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
