{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c128b7cf31fac5340062c9c2cf1e0b12c601ee2d5c10ef39cc191036fb2e688";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "flexmock is a testing library for Python that makes it easy to create mocks,stubs and fakes.";
    homepage = "https://flexmock.readthedocs.org";
    license = licenses.bsdOriginal;
  };
}
