{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, prometheus-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-openmetrics";
  version = "0.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/ZRngcMlroCVTvIl+30DR4SI8LsSnTovuzg3YduWgWA=";
  };

  propagatedBuildInputs = [
    aiohttp
    prometheus-client
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiohttp_openmetrics"
  ];

  meta = with lib; {
    description = "OpenMetrics provider for aiohttp";
    homepage = "https://github.com/jelmer/aiohttp-openmetrics/";
    changelog = "https://github.com/jelmer/aiohttp-openmetrics/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
