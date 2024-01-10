{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, ciso8601
, pandas
}:

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jy5mcg9wdz546s9wdwsgkxhm2ac4dmphd9vz243db39j1m0a3bj";
  };

  propagatedBuildInputs = [ aiohttp ciso8601 pandas ];

  # Tests require InfluxDB server
  doCheck = false;

  pythonImportsCheck = [ "aioinflux" ];

  meta = with lib; {
    description = "Asynchronous Python client for InfluxDB";
    homepage = "https://github.com/gusutabopb/aioinflux";
    license = licenses.mit;
    maintainers = with maintainers; [ liamdiprose lopsided98 ];
  };
}
