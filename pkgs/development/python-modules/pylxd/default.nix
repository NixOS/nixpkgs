{ lib, buildPythonPackage, fetchPypi, pbr, dateutil, ws4py, requests-unixsocket, requests-toolbelt, mock }:

buildPythonPackage rec {
  pname = "pylxd";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1db88l55q974fm9z5gllx3i8bkj0jzi25xrr5cs6id3bfy4zp8a7";
  };

  propagatedBuildInputs = [
    pbr
    dateutil
    ws4py
    requests-unixsocket
    requests-toolbelt
  ];

  # tests require an old version of requests-mock that we do not have a package for
  doCheck = false;
  pythonImportsCheck = [ "pylxd" ];

  meta = with lib; {
    description = "A Python library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
