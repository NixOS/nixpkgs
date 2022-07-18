{ lib
, buildPythonPackage
, fetchPypi
, flask
, jinja2
, speaklater
, babel
, pytz
}:

buildPythonPackage rec {
  pname = "Flask-Babel";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9faf45cdb2e1a32ea2ec14403587d4295108f35017a7821a2b1acb8cfd9257d";
  };

  propagatedBuildInputs = [ flask jinja2 speaklater babel pytz ];

  meta = with lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = "https://github.com/mitsuhiko/flask-babel";
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
