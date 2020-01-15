{ lib, buildPythonPackage, isPy3k, fetchPypi, aiohttp, async-timeout }:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.6.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0919hcycv2rkn99lv4dn78i827mgvm3vagm9xcc6qgawsli8vrlp";
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
