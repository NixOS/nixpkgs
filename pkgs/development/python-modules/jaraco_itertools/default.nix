{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1380ed961c9a4724f0bcca85d2bffebaa2507adfde535d5ee717441c9105fae";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ inflect more-itertools six ];
  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Tools for working with iterables";
    homepage = https://github.com/jaraco/jaraco.itertools;
    license = licenses.mit;
  };
}
