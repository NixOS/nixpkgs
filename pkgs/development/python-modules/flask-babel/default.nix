{ lib
, buildPythonPackage
, unittestCheckHook
, fetchPypi
, flask
, babel
, jinja2
, pytz
, speaklater
}:

buildPythonPackage rec {
  pname = "Flask-Babel";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9faf45cdb2e1a32ea2ec14403587d4295108f35017a7821a2b1acb8cfd9257d";
  };

  propagatedBuildInputs = [
    flask
    babel
    jinja2
    pytz
    speaklater
  ];

  unittestFlagsArray = [ "-s" "tests" ];

  meta = with lib; {
    description = "Adds i18n/l10n support to Flask applications";
    longDescription = ''
      Implements i18n and l10n support for Flask.
      This is based on the Python babel module as well as pytz both of which are
      installed automatically for you if you install this library.
    '';
    license = licenses.bsd2;
    maintainers = teams.sage.members;
    homepage = "https://github.com/python-babel/flask-babel";
  };
}
