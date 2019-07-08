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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66901483808839ed895a685ca7bc4731379f4a627d73a83b77f0df1847b14892";
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
