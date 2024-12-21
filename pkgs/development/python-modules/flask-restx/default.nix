{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aniso8601,
  jsonschema,
  flask,
  importlib-resources,
  werkzeug,
  pytz,
  faker,
  mock,
  blinker,
  py,
  pytest-flask,
  pytest-mock,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-restx";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = "flask-restx";
    rev = "refs/tags/${version}";
    hash = "sha256-CBReP/u96fsr28lMV1BfLjjdBMXEvsD03wvsxkIcteI=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pytestFlagsArray =
    [
      "--benchmark-disable"
      "--deselect=tests/test_inputs.py::URLTest::test_check"
      "--deselect=tests/test_inputs.py::EmailTest::test_valid_value_check"
      "--deselect=tests/test_logging.py::LoggingTest::test_override_app_level"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--deselect=tests/test_inputs.py::EmailTest::test_invalid_values_check"
    ];

  disabledTests = [
    # broken in werkzeug 2.3 upgrade
    "test_media_types_method"
    "test_media_types_q"
    # erroneous use of pytz
    # https://github.com/python-restx/flask-restx/issues/620
    # two fixes are proposed: one fixing just tests, and one removing pytz altogether.
    # we disable the tests in the meanwhile and let upstream decide
    "test_rfc822_value"
    "test_iso8601_value"
  ];

  pythonImportsCheck = [ "flask_restx" ];

  meta = with lib; {
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    homepage = "https://github.com/python-restx/flask-restx";
    changelog = "https://github.com/python-restx/flask-restx/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
