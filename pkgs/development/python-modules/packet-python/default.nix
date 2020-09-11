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
  version = "1.43.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "48fcc5ca6e7f3d84ef91016585d1894bb9deb3dae6591ffab90fdf05006c3e48";
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
