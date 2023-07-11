{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-inspect
, marshmallow-enum
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2/J+d7SQvUs7nXw1n+qwy0DQCplK28eUrbP7+yQPB7g=";
  };

  propagatedBuildInputs = [
    typing-inspect
    marshmallow-enum
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # fails with the following error and avoid dependency on mypy
    # mypy_main(None, text_io, text_io, [__file__], clean_exit=True)
    # TypeError: main() takes at most 4 arguments (5 given)
    "tests/test_annotations.py"
  ];

  pythonImportsCheck = [ "dataclasses_json" ];

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
