{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4672f807c0e22bde2606dd887b0358de1da77068d1a1afe6dd8e331d2391b02c";
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
