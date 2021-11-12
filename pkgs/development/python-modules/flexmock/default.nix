{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bb073f4b7b590672e8c312e73d6a14f88ae624a867b691462f9e8c24b9f19d1";
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
