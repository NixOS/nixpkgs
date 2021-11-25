{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, gtfs-realtime-bindings
, requests
}:

buildPythonPackage rec {
  pname = "pytransportnswv2";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyTransportNSWv2";
    inherit version;
    sha256 = "129rrqckqgfrwdx0b83dqphcv55cxs5i8jl1ascia7rpzjn109ah";
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
