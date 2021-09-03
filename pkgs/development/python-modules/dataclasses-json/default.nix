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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b8oWl8AteVuGYb4E+M9aDS2ERgnKN8wS17Y/Bs7ajcI=";
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
