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
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xv9br6mm5pcwfy10ykbc1c0n83fqyj1pa81z272kqww7wpkkp6j";
  };

  propagatedBuildInputs = [
    typing-inspect
    marshmallow-enum
  ];

  nativeCheckInputs = [
    hypothesis
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # mypy_main(None, text_io, text_io, [__file__], clean_exit=True)
    # TypeError: main() takes at most 4 arguments (5 given)
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
