{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b6qw3grhgx58kxlkj7mdma7xdvlj02zabvcf7w2qifnfjwwwcsh";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "flexmock is a testing library for Python that makes it easy to create mocks,stubs and fakes.";
    homepage = https://flexmock.readthedocs.org;
    license = licenses.bsdOriginal;
  };
}