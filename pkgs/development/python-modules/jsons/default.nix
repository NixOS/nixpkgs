{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
, pytestCheckHook
, typish
, tzdata
}:

buildPythonPackage rec {
  pname = "jsons";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "jsons";
    rev = "v${version}";
    sha256 = "0sdwc57f3lwzhbcapjdbay9f8rn65rlspxa67a2i5apcgg403qpc";
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

  pythonImportsCheck = [
    "jsons"
  ];

  meta = with lib; {
    description = "Turn Python objects into dicts or json strings and back";
    homepage = "https://github.com/ramonhagenaars/jsons";
    license = licenses.mit;
    maintainers = with maintainers; [ fmoda3 ];
  };
}
