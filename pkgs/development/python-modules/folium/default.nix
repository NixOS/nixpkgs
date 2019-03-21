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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04mhdl3k644j45rlfkamxz1paf58fxrmnwgvkrvza2fcwcs4nr9n";
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
