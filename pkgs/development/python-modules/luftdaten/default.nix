{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.3.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c298ea749ff4eec6a95e04023f9068d017acb02133f1fdcc38eb98e5ebc69442";
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
