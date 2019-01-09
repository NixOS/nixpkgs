{ stdenv, buildPythonPackage, fetchPypi
, pyparsing, six, pytest, pretend }:

buildPythonPackage rec {
  pname = "packaging";
  version = "18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807";
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
