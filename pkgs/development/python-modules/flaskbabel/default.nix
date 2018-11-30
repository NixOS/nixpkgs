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
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16b80cipdba9xj3jlaiaq6wgrgpjb70w3j01jjy9hbp4k71kd6yj";
  };

  propagatedBuildInputs = [ flask jinja2 speaklater Babel pytz ];

  meta = with stdenv.lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = https://github.com/mitsuhiko/flask-babel;
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
