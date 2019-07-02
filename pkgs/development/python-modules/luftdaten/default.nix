{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.6.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jxp9yfabdgn2d6w69ijrw1bk1d9g897425cyybiyc13zhhs0kwg";
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
