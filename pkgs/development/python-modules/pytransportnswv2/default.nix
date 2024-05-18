{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, gtfs-realtime-bindings
, requests
}:

buildPythonPackage rec {
  pname = "pytransportnswv2";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9bpIu+Uc6eFSEGeEfpVwfrhvLekR8qOd571qMnLTpVg=";
  };

  propagatedBuildInputs = [
    gtfs-realtime-bindings
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "TransportNSW" ];

  meta = with lib; {
    description = "Python module to access Transport NSW information";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
