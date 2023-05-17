{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aniso8601
, jsonschema
, flask
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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-alXuo6TGDX2ko6VIKpAtyrg0EBkxEnC3DabH8GYqEs0=";
  };

  propagatedBuildInputs = [
    aniso8601
    flask
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

  pythonImportsCheck = [
    "flask_restx"
  ];

  meta = with lib; {
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    homepage = "https://github.com/python-restx/flask-restx";
    changelog = "https://github.com/python-restx/flask-restx/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
