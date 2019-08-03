{ lib, buildPythonPackage, fetchPypi, flask, markdown }:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r23pdlaz6ibz9vml3m7v6v3firvykbrsi1zzxkdhls0zi9jq560";
  };

  propagatedBuildInputs = [ flask markdown ];

  meta = with lib; {
    homepage = https://github.com/miracle2k/flask-assets;
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
