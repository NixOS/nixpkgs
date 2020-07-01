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
  version = "1.42.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "c3342085b2b96591b9d214d10fe39d85e1a2487c5b0883a90ff0bf6123086f07";
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
