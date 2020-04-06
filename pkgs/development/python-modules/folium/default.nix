{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, numpy
, nbconvert
, pandas
, mock
, jinja2
, branca
, requests
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gcc267wxwxr57ry86pqpbiyfvl0g48hfvgy0f2mz9s58g87kgzd";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest nbconvert pandas mock ];
  propagatedBuildInputs = [ jinja2 branca requests numpy ];

  # No tests in archive
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = https://github.com/python-visualization/folium;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
