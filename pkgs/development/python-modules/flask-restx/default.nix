{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aniso8601
, jsonschema
, flask
, importlib-resources
, werkzeug
, pytz
, faker
, mock
, blinker
, py
, pytest-flask
, pytest-mock
, pytest-benchmark
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-restx";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-CBReP/u96fsr28lMV1BfLjjdBMXEvsD03wvsxkIcteI=";
  };

  propagatedBuildInputs = [
    aniso8601
    flask
    importlib-resources
    jsonschema
    pytz
    werkzeug
  ];

  nativeCheckInputs = [
    blinker
    faker
    mock
    py
    pytest-benchmark
    pytest-flask
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
    "--deselect=tests/test_inputs.py::URLTest::test_check"
    "--deselect=tests/test_inputs.py::EmailTest::test_valid_value_check"
    "--deselect=tests/test_logging.py::LoggingTest::test_override_app_level"
  ];

  disabledTests = [
    # broken in werkzeug 2.3 upgrade
    "test_media_types_method"
    "test_media_types_q"
  ];

  pythonImportsCheck = [
    "flask_restx"
  ];

  meta = with lib; {
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    homepage = "https://github.com/python-restx/flask-restx";
    changelog = "https://github.com/python-restx/flask-restx/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
