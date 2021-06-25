{ lib
, buildPythonPackage
, fetchFromGitHub
, stringcase
, typing-inspect
, marshmallow-enum
, hypothesis
, mypy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gcnm41rwg0jvq4vhr57vv9hyasws425zl8h4p05x2nzq86l0w1n";
  };

  propagatedBuildInputs = [
    stringcase
    typing-inspect
    marshmallow-enum
  ];

  checkInputs = [
    hypothesis
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Type annotations check failed
    "test_type_hints"
  ];

  pythonImportsCheck = [ "dataclasses_json" ];

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
