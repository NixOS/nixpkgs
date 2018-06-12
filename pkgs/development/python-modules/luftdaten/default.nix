{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "75fb177f61904dd1a7f93c1fa6c7cd468fd4a2e04ca45a87d37c802d290d17ad";
  };

  propagatedBuildInputs = [ aiohttp async-timeout ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Python API for interacting with luftdaten.info";
    homepage = https://github.com/fabaff/python-luftdaten;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
