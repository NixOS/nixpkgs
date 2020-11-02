{ lib, stdenv, fetchPypi, buildPythonPackage
, boto3, requests, datadog, configparser, python
}:

buildPythonPackage rec {
  pname = "gradient_statsd";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "iWlNX43ZtvU73wz4+8DgDulQNOnssJGxTBkvAaLj530=";
  };

  propagatedBuildInputs = [ requests datadog ]
    ++ lib.optional python.isPy2 configparser;

  pythonImportsCheck = [ "gradient_statsd" ];

  meta = with stdenv.lib; {
    description = "Wrapper around the DogStatsd client";
    homepage    = "https://paperspace.com";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
