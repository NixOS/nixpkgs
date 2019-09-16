{ lib
, buildPythonPackage
, fetchPypi
, pytest-astropy
, semantic-version
, pyyaml
, jsonschema
, six
, numpy
, isPy27
, astropy
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "2.3.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d02e936a83abd206e7bc65050d94e8848da648344dbec9e49dddc2bdc3bd6870";
  };

  checkInputs = [
    pytest-astropy
    astropy
  ];

  propagatedBuildInputs = [
    semantic-version
    pyyaml
    jsonschema
    six
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = https://github.com/spacetelescope/asdf;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
