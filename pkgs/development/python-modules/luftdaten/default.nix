{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.6.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w1f0kmiwslg1dxn7gq0ak8f5wajlwl03r5zklshjc11j34b4d5i";
  };

  propagatedBuildInputs = [ aiohttp async-timeout ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Python API for interacting with luftdaten.info";
    homepage = "https://github.com/fabaff/python-luftdaten";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
