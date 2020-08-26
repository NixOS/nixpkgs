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
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "540789abc21872469e52c59ac3962c61259a8df557feadd6514eb23eb0a64ca7";
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
