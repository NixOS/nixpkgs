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
}:

buildPythonPackage rec {
  pname = "folium";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "748944521146d85c6cd6230acf234e885864cd0f42fea3758d655488517e5e6e";
  };

  postPatch = ''
    # Causes trouble because a certain file cannot be found
    rm tests/notebooks/test_notebooks.py
  '';

  checkInputs = [ pytest numpy nbconvert pandas mock ];
  propagatedBuildInputs = [ jinja2 branca six ];

  #
#   doCheck = false;

#   checkPhase = ''
#     py.test -k 'not test_notebooks'
#   '';

  meta = {
    description = "Make beautiful maps with Leaflet.js & Python";
    homepage = https://github.com/python-visualization/folium;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
