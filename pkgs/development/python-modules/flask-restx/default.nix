{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  aniso8601,
  flask,
  importlib-resources,
  jsonschema,
  pytz,
  werkzeug,

  # tests
  blinker,
  faker,
  mock,
  py,
  pytest-benchmark,
  pytest-flask,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-restx";
  version = "1.3.2";
  pyproject = true;

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = "flask-restx";
    tag = finalAttrs.version;
    hash = "sha256-KSHRfGX6M/w09P35A68u7uzMKaRioytScPh0Sw8JBfw=";
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
    pytest-vcr
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-disable"
  ];
  disabledTestPaths = [
    "tests/test_inputs.py::URLTest::test_check"
    "tests/test_inputs.py::EmailTest::test_valid_value_check"
    "tests/test_logging.py::LoggingTest::test_override_app_level"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_inputs.py::EmailTest::test_invalid_values_check"
  ];

  disabledTests = [
    "test_specs_endpoint_host_and_subdomain"
    # broken in werkzeug 2.3 upgrade
    "test_media_types_method"
    "test_media_types_q"
    # erroneous use of pytz
    # https://github.com/python-restx/flask-restx/issues/620
    # two fixes are proposed: one fixing just tests, and one removing pytz altogether.
    # we disable the tests in the meanwhile and let upstream decide
    "test_rfc822_value"
    "test_iso8601_value"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Wildcard.__init__() takes 2 positional arguments but 3 were given
    "test_description"
    "test_max_length"
    "test_max_length_as_callable"
    "test_min_length"
    "test_min_length_as_callable"
    "test_pattern"
    "test_readonly"
    "test_required"
    "test_title"
  ];

  pythonImportsCheck = [ "flask_restx" ];

  meta = {
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    homepage = "https://github.com/python-restx/flask-restx";
    changelog = "https://github.com/python-restx/flask-restx/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
