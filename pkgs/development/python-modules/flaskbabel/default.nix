{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, jinja2
, speaklater
, Babel
, pytz
}:

buildPythonPackage rec {
  pname = "Flask-Babel";
  version = "2.0.0";

  src = fetchFromGitHub {
     owner = "mitsuhiko";
     repo = "flask-babel";
     rev = "v2.0.0";
     sha256 = "1n6d499viq8crmgvp04vi3nzh1bc4n60wjgh57djkzxm0ssvxvpd";
  };

  propagatedBuildInputs = [ flask jinja2 speaklater Babel pytz ];

  meta = with lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = "https://github.com/mitsuhiko/flask-babel";
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
