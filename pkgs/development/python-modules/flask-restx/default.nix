{ lib
, buildPythonPackage
, fetchFromGitHub
, aniso8601
, jsonschema
, flask
, werkzeug
, pytz
, faker
, six
, enum34
, isPy27
, mock
, blinker
, pytest-flask
, pytest-mock
, pytest-benchmark
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-restx";
  version = "0.3.0";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = version;
    sha256 = "0aj13nd3z71gb8c2kqiaz3f9k7jr0srlvrsx8hpz4nkpki8jiz2s";
  };

  propagatedBuildInputs = [ aniso8601 jsonschema flask werkzeug pytz six ]
    ++ lib.optionals isPy27 [ enum34 ];

  checkInputs = [ pytestCheckHook faker mock pytest-flask pytest-mock pytest-benchmark blinker ];

  pytestFlagsArray = [
    "--benchmark-disable"
    "--deselect=tests/test_inputs.py::URLTest::test_check"
    "--deselect=tests/test_inputs.py::EmailTest::test_valid_value_check"
    "--deselect=tests/test_logging.py::LoggingTest::test_override_app_level"
  ];

  meta = with lib; {
    homepage = "https://flask-restx.readthedocs.io/en/${version}/";
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    changelog = "https://github.com/python-restx/flask-restx/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
