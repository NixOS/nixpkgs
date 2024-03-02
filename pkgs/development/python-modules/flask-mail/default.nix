{ lib, buildPythonPackage, fetchPypi,
  blinker, flask, mock, nose, speaklater
}:

buildPythonPackage rec {
  pname = "flask-mail";
  version = "0.9.1";
  format = "setuptools";

  meta = {
    description = "Flask-Mail is a Flask extension providing simple email sending capabilities.";
    homepage = "https://pypi.python.org/pypi/Flask-Mail";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    pname = "Flask-Mail";
    inherit version;
    hash = "sha256-IuXrmpQL9Ae88wQQ7MNwjzxWzESynDThcm/oUAaTX0E=";
  };

  propagatedBuildInputs = [ blinker flask ];
  buildInputs = [ blinker mock nose speaklater ];

  doCheck = false;
}
