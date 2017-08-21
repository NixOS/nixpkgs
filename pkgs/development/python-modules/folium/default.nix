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
  version = "0.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7729ddd6766b9c5dab17b3709e2387935fd5c655872f1cbab7b7036474415217";
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
