{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  protobuf,
  pycryptodome,
  requests,
}:

buildPythonPackage rec {
  version = "0.4.4.5";
  pname = "matlink-gpapi";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    sha256 = "0s45yb2xiq3pc1fh4bygfgly0fsjk5fkc4wckbckn3ddl7v7vz8c";
  };

  build-system = [ setuptools ];

  # the expected protoc is too old, so fall back to the pure python implementation
  preBuild = ''
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
  '';

  dependencies = [
    cryptography
    protobuf
    pycryptodome
    requests
  ];

  # package doesn't contain unit tests
  # scripts in ./test require networking
  doCheck = false;

  pythonImportsCheck = [ "gpapi.googleplay" ];

  meta = {
    homepage = "https://github.com/NoMore201/googleplay-api";
    license = lib.licenses.gpl3Only;
    description = "Google Play Unofficial Python API";
    maintainers = with lib.maintainers; [ schnusch ];
  };
}
