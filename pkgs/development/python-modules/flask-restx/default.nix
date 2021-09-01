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
  version = "0.4.0";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = version;
    sha256 = "sha256-jM0QJ/klbWh3qho6ZQOH2n1qaguK9C98QIuSfqpI8xA=";
  };

  postPatch = ''
    # https://github.com/python-restx/flask-restx/pull/341
    substituteInPlace requirements/install.pip \
      --replace "Flask>=0.8, <2.0.0" "Flask>=0.8, !=2.0.0" \
      --replace "werkzeug <2.0.0" "werkzeug !=2.0.0"
  '';

  propagatedBuildInputs = [ aniso8601 jsonschema flask werkzeug pytz six ]
    ++ lib.optionals isPy27 [ enum34 ];

  checkInputs = [ pytestCheckHook faker mock pytest-flask pytest-mock pytest-benchmark blinker ];

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
