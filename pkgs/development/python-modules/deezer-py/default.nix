{ lib
, buildPythonPackage
, fetchPypi
, requests
, eventlet
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2g/GbJ/XMzyT2SDGaBXkf0LZrebvqFzW8yGsEBzK5Gk=";
  };

  propagatedBuildInputs = [
    requests
    eventlet
  ];

  doCheck = false; # tcp: protocol not found

  meta = with lib; {
    description = "A wrapper for all Deezer's APIs";
    homepage = "https://git.rip/RemixDev/deezer-py";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
  };
}
