{
  lib,
  buildPythonPackage,
  certifi,
  chardet,
  datadog,
  decorator,
  fetchPypi,
  idna,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "gradient-statsd";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "gradient_statsd";
    inherit version;
    hash = "sha256-iWlNX43ZtvU73wz4+8DgDulQNOnssJGxTBkvAaLj530=";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    datadog
    decorator
    idna
    requests
    urllib3
  ];

  pythonImportsCheck = [ "gradient_statsd" ];

  # Pypi does not contain tests
  doCheck = false;

  meta = {
    description = "Wrapper around the DogStatsd client";
    homepage = "https://paperspace.com";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
