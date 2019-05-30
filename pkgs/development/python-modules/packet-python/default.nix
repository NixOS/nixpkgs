{ lib
, buildPythonPackage
, fetchPypi
, requests
, python

# For tests/setup.py
, pytestrunner
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

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s test
  '';

  # Not all test files are included in archive
  doCheck = false;

  meta = {
    description = "A Python client for the Packet API.";
    homepage    = "https://github.com/packethost/packet-python";
    license     = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ dipinhora ];
  };
}
