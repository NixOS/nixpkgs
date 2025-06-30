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
  version = "0.4.4.5";
  format = "setuptools";
  pname = "matlink-gpapi";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0s45yb2xiq3pc1fh4bygfgly0fsjk5fkc4wckbckn3ddl7v7vz8c";
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
    maintainers = with maintainers; [ schnusch ];
  };
}
