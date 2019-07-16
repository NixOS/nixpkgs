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
  version = "1.38.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1lh97la51fa3nxjl4ngsanrxw6qq5jwwn0dxj2f0946m043200xl";
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
