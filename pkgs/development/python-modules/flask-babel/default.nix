{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, flask
, Babel
, jinja2
, pytz
, speaklater
}:

buildPythonPackage rec {
  pname = "Flask-Babel";
  version = "2.0.0";

  src = fetchFromGitHub {
     owner = "python-babel";
     repo = "flask-babel";
     rev = "v2.0.0";
     sha256 = "1n6d499viq8crmgvp04vi3nzh1bc4n60wjgh57djkzxm0ssvxvpd";
  };

  propagatedBuildInputs = [
    flask
    Babel
    jinja2
    pytz
    speaklater
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

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
