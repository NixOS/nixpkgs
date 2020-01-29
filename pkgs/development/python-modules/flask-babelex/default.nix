{ lib
, buildPythonPackage
, fetchPypi
, flask
, Babel
, speaklater
, jinja2
, pytest
}:

buildPythonPackage rec {
  pname = "flask-babelex";
  version = "0.9.3";

  src = fetchPypi {
    inherit version;
    pname = "Flask-BabelEx";
    sha256 = "cf79cdedb5ce860166120136b0e059e9d97b8df07a3bc2411f6243de04b754b4";
  };

  propagatedBuildInputs = [
    flask
    Babel
    speaklater
    jinja2
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # Disabled 3 tests failing due to string representations of dates:
    # Like "12. April 2010 um 15:46:00 MESZ" != 12. "April 2010 15:46:00 MESZ"

    pytest tests/tests.py -k "not test_init_app \
                              and not test_custom_locale_selector \
                              and not test_basics"
  '';

  meta = with lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = https://github.com/mrjoes/flask-babelex;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
