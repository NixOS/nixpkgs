{ lib
, buildPythonPackage
, fetchPypi
, requests
, python

# For tests/setup.py
, pytest
, pytestrunner
, requests-mock
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.41.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "685021502293f6b2e733376bcd0fef3f082c1a66c27072d92f483e27e387ad43";
  };
  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ requests ];
  checkInputs = [
    pytest
    pytestrunner
    requests-mock
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = {
    description = "A Python client for the Packet API.";
    homepage    = "https://github.com/packethost/packet-python";
    license     = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ dipinhora ];
  };
}
