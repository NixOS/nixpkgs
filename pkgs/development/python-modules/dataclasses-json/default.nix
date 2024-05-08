{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, marshmallow-enum
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
, pythonOlder
, typing-inspect
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.6.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = "dataclasses-json";
    rev = "refs/tags/v${version}";
    hash = "sha256-YkGxUQgnUB7WfpsZz74b3j/TIqJi2ihsk9Ib05S7uPM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
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

  pythonImportsCheck = [
    "dataclasses_json"
  ];

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    changelog = "https://github.com/lidatong/dataclasses-json/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
