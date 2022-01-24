{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-inspect
, marshmallow-enum
, hypothesis
, mypy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
    rev = "v${version}";
    sha256 = "09253p0zjqfaqap7jgfgjl1jswwnz7mb6x7dqix09id92mnb89mf";
  };

  propagatedBuildInputs = [
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
