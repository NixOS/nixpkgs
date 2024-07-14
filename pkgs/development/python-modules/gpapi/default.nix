{
  buildPythonPackage,
  cryptography,
  fetchPypi,
  lib,
  protobuf,
  pycryptodome,
  requests,
}:

buildPythonPackage rec {
  version = "0.4.4";
  format = "setuptools";
  pname = "gpapi";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-HA06ie25ny7AXI7AvZgezvowfZ3ExalY8HDkk7betyo=";
  };

  # package doesn't contain unit tests
  # scripts in ./test require networking
  doCheck = false;

  pythonImportsCheck = [ "gpapi.googleplay" ];

  propagatedBuildInputs = [
    cryptography
    protobuf
    pycryptodome
    requests
  ];

  meta = with lib; {
    homepage = "https://github.com/NoMore201/googleplay-api";
    license = licenses.gpl3Only;
    description = "Google Play Unofficial Python API";
    maintainers = with maintainers; [ ];
  };
}
