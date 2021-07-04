{ lib, buildPythonPackage, fetchPypi, python-dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76461f2dbdf502261c69ddecd858eaf4164fbcfbf05aa456f3927fc2ab0315de";
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
