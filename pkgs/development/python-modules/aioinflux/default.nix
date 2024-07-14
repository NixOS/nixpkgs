{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  ciso8601,
  pandas,
}:

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cg0FapBprDaI+Ds1eGsjTIkK+3yaN560IeU3nh6rxcs=";
  };

  propagatedBuildInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [
      liamdiprose
      lopsided98
    ];
  };
}
