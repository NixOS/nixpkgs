{ lib
, buildPythonPackage
, certifi
, chardet
, datadog
, decorator
, fetchPypi
, idna
, requests
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gradient-statsd";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  pythonImportsCheck = [
    "gradient_statsd"
  ];

  # Pypi does not contain tests
  doCheck = false;

  meta = with lib; {
    description = "Wrapper around the DogStatsd client";
    homepage = "https://paperspace.com";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.unix;
  };
}
