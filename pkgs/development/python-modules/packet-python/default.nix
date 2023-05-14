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
  version = "1.44.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WVfMELOoml7Hx78jy6TAwlFRLuSQu9dtsb6Khs6/cgI=";
  };
  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ requests ];
  nativeCheckInputs = [
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
