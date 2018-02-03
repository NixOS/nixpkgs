{ lib
, buildPythonPackage
, fetchPypi
, requests
, python
}:

buildPythonPackage rec {
  pname = "packet-python";
  version = "1.33";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0bmvfmvjm8jx0y8sv0jf5mhv0h3v8idx0sc5myxs7ig200584dd3";
  };
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