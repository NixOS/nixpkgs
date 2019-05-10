{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, Babel
, jinja2
, pytz
, speaklater
}:

buildPythonPackage rec {
  pname = "Flask-BabelEx";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d2lnw2dwhv23x0w4fvsy26ppng9b7hb0dh129k031nfnpnwsyfg";
  };

  propagatedBuildInputs = [
    flask
    Babel
    jinja2
    pytz
    speaklater
  ];

  meta = with stdenv.lib; {
    description = "Adds i18n/l10n support to Flask applications";
    longDescription = ''
      This is fork of official Flask-Babel extension with following features:

      1. It is possible to use multiple language catalogs in one Flask application;
      2. Localization domains: your extension can package localization file(s) and use them if necessary;
      3. Does not reload localizations for each request.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/mrjoes/flask-babelex;
  };
}
