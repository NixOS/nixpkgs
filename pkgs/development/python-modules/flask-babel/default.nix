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
  pname = "Flask-Babel";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmb165vkwv5v7dxsxa2i3zhafns0fh938m2zdcrv4d8z5l099yn";
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

  meta = with stdenv.lib; {
    description = "Adds i18n/l10n support to Flask applications";
    longDescription = ''
      Implements i18n and l10n support for Flask.
      This is based on the Python babel module as well as pytz both of which are
      installed automatically for you if you install this library.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ timokau ];
    homepage = "https://github.com/python-babel/flask-babel";
  };
}
