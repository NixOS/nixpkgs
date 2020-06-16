{ lib, buildPythonPackage, fetchPypi, isPy27, requests, pytest }:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "etelemetry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfb58f58e98f63eae20caffb8514fb68c572332aa6e773cf3fcbde9b408d88e7";
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
