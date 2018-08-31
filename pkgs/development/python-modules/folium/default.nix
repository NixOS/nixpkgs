{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, nbconvert
, pandas
, mock
, jinja2
, branca
, six
, requests
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yfb8ygq67m149n72bb8h7dk9mx8d3ivc5ygqwdj4q8qggj1ns08";
  };

  checkInputs = [ pytest numpy nbconvert pandas mock ];
  propagatedBuildInputs = [ jinja2 branca six requests numpy ];

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
