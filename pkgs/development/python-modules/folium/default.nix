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
    sha256 = "08681be47b1861221bc7cf17b6e368a8d734db81682d716c22a11e839f47cb79";
  };

  checkInputs = [ pytest nbconvert pandas mock ];
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
