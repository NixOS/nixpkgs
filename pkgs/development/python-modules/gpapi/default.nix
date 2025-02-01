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
    sha256 = "0ampvsv97r3hy1cakif4kmyk1ynf3scbvh4fbk02x7xrxn4kl38w";
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
    maintainers = [ ];
  };
}
