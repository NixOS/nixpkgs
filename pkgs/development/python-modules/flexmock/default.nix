{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "031c624pdqm7cc0xh4yz5k69gqxn2bbrjz13s17684q5shn0ik21";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "flexmock is a testing library for Python that makes it easy to create mocks,stubs and fakes.";
    homepage = http://flexmock.readthedocs.org;
    license = licenses.bsdOriginal;
  };
}