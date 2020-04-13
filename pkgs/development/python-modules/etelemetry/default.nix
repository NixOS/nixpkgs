{ lib, buildPythonPackage, fetchPypi, requests, pytest }:

buildPythonPackage rec {
  version = "0.1.2";
  pname = "etelemetry";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m3dqvs3xbckmjiwppy366qmgzx0z917j1d7dadfl3bprgipy51j";
  };

  propagatedBuildInputs = [ requests ];

  # all 2 of the tests both try to pull down from a url
  doCheck = false;

  pythonImportsCheck = [
    "etelemetry"
    "etelemetry.client"
    "etelemetry.config"
  ];

  meta = with lib; {
    description = "Lightweight python client to communicate with the etelemetry server";
    homepage = "https://github.com/mgxd/etelemetry-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
