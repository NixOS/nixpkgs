{ lib, buildPythonPackage, fetchPypi, pbr, dateutil, ws4py, requests-unixsocket, requests-toolbelt }:

buildPythonPackage rec {
  pname = "pylxd";
  version = "2.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0apzvqa6wavn4b7ajj8xdvrd76dg8a5fr7kjv77mymsaqpy1a54v";
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

  meta = with lib; {
    description = "A Python library for interacting with the LXD REST API";
    homepage = "https://pylxd.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
