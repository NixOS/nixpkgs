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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f25fhwxnix8hddzf67barzjwwsvpww112zisrvz2lpl08j388rn";
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
