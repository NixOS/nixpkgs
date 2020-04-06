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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmb165vkwv5v7dxsxa2i3zhafns0fh938m2zdcrv4d8z5l099yn";
  };

  propagatedBuildInputs = [ flask jinja2 speaklater Babel pytz ];

  meta = with stdenv.lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = "https://github.com/mitsuhiko/flask-babel";
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
