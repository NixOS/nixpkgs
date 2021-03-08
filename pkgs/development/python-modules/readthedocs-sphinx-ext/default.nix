{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytest
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "209c4b5ecf233b8bb44fcb8b4548460b0806e347ce50fd8172adcb7d23969a4a";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = "https://github.com/rtfd/readthedocs-sphinx-ext";
    license = licenses.mit;
  };
}
