{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, aniso8601
, jsonschema
, flask
, werkzeug
, pytz
, faker
, six
, mock
, blinker
, pytest-flask
, pytest-mock
, pytest-benchmark
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-restx";
  version = "0.5.1";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = version;
    sha256 = "18vrmknyxw6adn62pz3kr9kvazfgjgl4pgimdf8527fyyiwcqy15";
  };

  patches = [
    # Fixes werkzeug 2.1 compatibility
    (fetchpatch {
      # https://github.com/python-restx/flask-restx/pull/427
      url = "https://github.com/python-restx/flask-restx/commit/bb72a51860ea8a42c928f69bdd44ad20b1f9ee7e.patch";
      hash = "sha256-DRH3lI6TV1m0Dq1VyscL7GQS26OOra9g88dXZNrNpmQ=";
    })
    (fetchpatch {
      # https://github.com/python-restx/flask-restx/pull/427
      url = "https://github.com/python-restx/flask-restx/commit/bb3e9dd83b9d4c0d0fa0de7d7ff713fae71eccee.patch";
      hash = "sha256-HJpjG4aQWzEPCMfbXfkw4mz5TH9d89BCvGH2dE6Jfv0=";
    })
  ];

  propagatedBuildInputs = [
    aniso8601
    flask
    jsonschema
    pytz
    six
    werkzeug
  ];

  checkInputs = [
    blinker
    faker
    mock
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

  pythonImportsCheck = [ "flask_restx" ];

  meta = with lib; {
    homepage = "https://flask-restx.readthedocs.io/en/${version}/";
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    changelog = "https://github.com/python-restx/flask-restx/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
