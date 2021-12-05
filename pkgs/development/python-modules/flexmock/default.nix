{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c51371767f968e1d2f505138de72b07704ecebc9b34e0b52ffdeeb510685c3f";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description =
      "flexmock is a testing library for Python that makes it easy to create mocks,stubs and fakes.";
    homepage = "https://flexmock.readthedocs.org";
    license = licenses.bsdOriginal;
  };
}
