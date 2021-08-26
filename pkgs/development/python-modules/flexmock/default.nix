{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0abedcc894a817452ae3902e8e00f0a8d2c66497f63caaaab03cbd464ea63d04";
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
