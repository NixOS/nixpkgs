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
  version = "1.44.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "4af12f2fbcc9713878ab4ed571e9fda028bc68add34cde0e7226af4d833a4d38";
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
