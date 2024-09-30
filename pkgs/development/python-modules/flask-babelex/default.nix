{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  babel,
  speaklater,
  jinja2,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "flask-babelex";
  version = "0.9.4";
  format = "setuptools";

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
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [ "tests/tests.py" ];

  disabledTests = [
    # Disabled 3 tests failing due to string representations of dates:
    # Like "12. April 2010 um 15:46:00 MESZ" != 12. "April 2010 15:46:00 MESZ"
    "test_init_app"
    "test_custom_locale_selector"
    "test_basics"
    "test_non_initialized"
    "test_refreshing"
  ];

  meta = with lib; {
    description = "Adds i18n/l10n support to Flask applications";
    homepage = "https://github.com/mrjoes/flask-babelex";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
