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
  version = "1.43.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "e333fb5ce45a3f283ddeb6261d061b39328b82eb440a89233fa08ce3fec2fcf0";
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
