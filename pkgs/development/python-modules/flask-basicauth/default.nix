{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-BasicAuth";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3169SJ3AkUwiRBnaBZ2ZHrcpiKAc3UuVbVKTLOfVAf8=";
  };

  propagatedBuildInputs = [ flask ];

  # fails because use a deprecated flask style
  doCheck = false;

  meta = with lib; {
    description = "HTTP basic access authentication for Flask.";
    homepage = "https://github.com/jpvanhal/flask-basicauth://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}

