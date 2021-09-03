{ lib, buildPythonPackage, fetchPypi, python-dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22b8ffa7587d50aaf65f3009f1d55ef7287da8260eaf4655a5837e33479216c3";
  };

  propagatedBuildInputs = [ python-dateutil flask pyjwt werkzeug ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with lib; {
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
