{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, jinja2
, speaklater
, Babel
, pytz
}:

buildPythonPackage rec {
  pname = "Flask-Babel";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "316ad183e42003f3922957fa643d0a1e8e34a0f0301a88c3a8f605bc37ba5c86";
  };

  propagatedBuildInputs = [ flask jinja2 speaklater Babel pytz ];

  meta = with stdenv.lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = https://github.com/mitsuhiko/flask-babel;
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
