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
  version = "1.44.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "4ce0827bc41d5bf5558284c18048344343f7c4c6e280b64bbe53fb51ab454892";
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
