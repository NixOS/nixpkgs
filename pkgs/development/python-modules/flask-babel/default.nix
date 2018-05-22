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
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ff9n165vhf1nhv6807ckhpp224jw7k7sd7jz5kfh3sbpl85gmy0";
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
    homepage = https://github.com/python-babel/flask-babel;
  };
}
