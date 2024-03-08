{ lib, buildPythonPackage, fetchPypi, isPy27, ci-info, ci-py, requests }:

buildPythonPackage rec {
  version = "0.2.1";
  format = "setuptools";
  pname = "etelemetry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rw8im09ppnb7z7p7rx658rp5ib8zca8byxg1kiflqwgx5c8zddz";
  };

  propagatedBuildInputs = [ ci-info ci-py requests ];

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
