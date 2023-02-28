{ lib
, buildPythonPackage
, fetchPypi
, flask
, babel
, speaklater
, jinja2
, pytest
}:

buildPythonPackage rec {
  pname = "flask-babelex";
  version = "0.9.4";

  src = fetchPypi {
    inherit version;
    pname = "Flask-BabelEx";
    sha256 = "09yfr8hlwvpgvq8kp1y7qbnnl0q28hi0348bv199ssiqx779r99r";
  };

  propagatedBuildInputs = [
    flask
    babel
    speaklater
    jinja2
  ];

  nativeCheckInputs = [
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
    homepage = "https://github.com/mrjoes/flask-babelex";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
