{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, prometheus-client
}:

buildPythonPackage rec {
  pname = "aiohttp-openmetrics";
  version = "0.0.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIVUkjyn+iQSMZZ6dNmmimvbt+t+uxOYv2QEDk/dA+g=";
  };

  propagatedBuildInputs = [
    aiohttp
    prometheus-client
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohttp_openmetrics" ];

  meta = with lib; {
    description = "OpenMetrics provider for aiohttp";
    homepage = "https://github.com/jelmer/aiohttp-openmetrics/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
