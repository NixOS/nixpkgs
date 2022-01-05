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
  version = "0.12.1.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e91e57d8298f3ccf4cce3c5e065bea6eb17033e3c5432b8a22214009c266b2ab";
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
