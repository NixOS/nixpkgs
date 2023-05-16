{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hypothesis
, marshmallow-enum
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
, pythonOlder
, typing-inspect
=======
, typing-inspect
, marshmallow-enum
, hypothesis
, mypy
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
<<<<<<< HEAD
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "0.5.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lidatong";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-jv00WqSC/KCM+6+LtsCAQcqZTBbV1pavEqsCP/F84VU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

=======
    rev = "v${version}";
    sha256 = "1xv9br6mm5pcwfy10ykbc1c0n83fqyj1pa81z272kqww7wpkkp6j";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    typing-inspect
    marshmallow-enum
  ];

  nativeCheckInputs = [
    hypothesis
<<<<<<< HEAD
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
=======
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # mypy_main(None, text_io, text_io, [__file__], clean_exit=True)
    # TypeError: main() takes at most 4 arguments (5 given)
    "test_type_hints"
  ];

  pythonImportsCheck = [ "dataclasses_json" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
<<<<<<< HEAD
    changelog = "https://github.com/lidatong/dataclasses-json/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
