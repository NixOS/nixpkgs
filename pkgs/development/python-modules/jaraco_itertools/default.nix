{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d09zpi593bhr56rwm41kzffr18wif98plgy6xdy0zrbdwfarrxl";
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
