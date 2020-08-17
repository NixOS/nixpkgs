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
  version = "0.2.0";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-restx";
    repo = pname;
    rev = version;
    sha256 = "0xf2vkmdngp9cv9klznizai4byxjcf0iqh1pr4b83nann0jxqwy7";
  };

  propagatedBuildInputs = [ aniso8601 jsonschema flask werkzeug pytz six ]
    ++ lib.optionals isPy27 [ enum34 ];

  checkInputs = [ pytestCheckHook faker mock pytest-flask pytest-mock pytest-benchmark blinker ];

  pytestFlagsArray = [
    "--benchmark-disable"
    "--deselect=tests/test_inputs.py::URLTest::test_check"
    "--deselect=tests/test_inputs.py::EmailTest::test_valid_value_check"
  ];

  meta = with lib; {
    homepage = "https://flask-restx.readthedocs.io/en/${version}/";
    description = "Fully featured framework for fast, easy and documented API development with Flask";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
