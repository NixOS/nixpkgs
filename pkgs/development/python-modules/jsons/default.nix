{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, typish
, tzdata
}:

buildPythonPackage rec {
  pname = "jsons";
  version = "1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "jsons";
    rev = "refs/tags/v${version}";
    hash = "sha256-7OIByHvsqhKFOkb1q2kuxmbkkleryavYgp/T4U5hvGk=";
  };

  propagatedBuildInputs = [
    typish
  ];

  nativeCheckInputs = [
    attrs
    pytestCheckHook
    tzdata
  ];

  disabledTestPaths = [
    # These tests are based on timings, which fail
    # on slow or overloaded machines.
    "tests/test_performance.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/ramonhagenaars/jsons/issues/187
    "test_dump_load_parameterized_collections"
  ];

  pythonImportsCheck = [
    "jsons"
  ];

  meta = with lib; {
    description = "Turn Python objects into dicts or json strings and back";
    homepage = "https://github.com/ramonhagenaars/jsons";
    changelog = "https://github.com/ramonhagenaars/jsons/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fmoda3 ];
  };
}
