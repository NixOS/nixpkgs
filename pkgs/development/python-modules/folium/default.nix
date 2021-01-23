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
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d45ace0a813ae65f202ce0356eb29c40a5e8fde071e4d6b5be0a89587ebaeab2";
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
    homepage = "https://github.com/python-visualization/folium";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
