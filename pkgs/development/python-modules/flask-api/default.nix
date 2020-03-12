{ lib, buildPythonPackage, fetchPypi, flask, markdown }:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6986642e5b25b7def710ca9489ed2b88c94006bfc06eca01c78da7cf447e66e5";
  };

  propagatedBuildInputs = [ flask markdown ];

  meta = with lib; {
    homepage = https://github.com/miracle2k/flask-assets;
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
