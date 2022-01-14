{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44f702c0d0adde7085b4c7afe9adab50b01b724aceeb7e49b29f5632e6325ce8";
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
