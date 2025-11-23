{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  ciso8601,
  setuptools,
  pandas,
}:

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cg0FapBprDaI+Ds1eGsjTIkK+3yaN560IeU3nh6rxcs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ciso8601
    pandas
  ];

  # Tests require InfluxDB server
  doCheck = false;

  pythonImportsCheck = [ "aioinflux" ];

  meta = with lib; {
    description = "Asynchronous Python client for InfluxDB";
    homepage = "https://github.com/gusutabopb/aioinflux";
    changelog = "https://github.com/gusutabopb/aioinflux/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      liamdiprose
      lopsided98
    ];
  };
}
