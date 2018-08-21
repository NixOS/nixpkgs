{ lib, buildPythonPackage, fetchPypi, flask, markdown }:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dffcy2hdkajbvl2wkz9dam49v05x9d87cf2mh2cyvza2c5ah47w";
  };

  propagatedBuildInputs = [ flask markdown ];

  meta = with lib; {
    homepage = https://github.com/miracle2k/flask-assets;
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
