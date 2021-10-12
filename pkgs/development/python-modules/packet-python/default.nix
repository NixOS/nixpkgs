{ lib
, buildPythonPackage
, fetchPypi
, requests
, python

# For tests/setup.py
, pytest
, pytest-runner
, requests-mock
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.44.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ec0f40465fad5260a1b2c1ad39dc12c5df65828e171bf2aafb13c1c3883628ba";
  };
  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ requests ];
  checkInputs = [
    pytest
    pytest-runner
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
