{ lib, buildPythonPackage, fetchPypi
, pytest, mock }:

buildPythonPackage rec {
  pname = "jsonref";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UdPhi4PKcXD/UShqDhpnGdi3/Mer2xaxiTlahTaZa5c=";
  };

  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test tests.py
  '';

  meta = with lib; {
    description = "An implementation of JSON Reference for Python";
    homepage    = "https://github.com/gazpachoking/jsonref";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms   = platforms.all;
  };
}
