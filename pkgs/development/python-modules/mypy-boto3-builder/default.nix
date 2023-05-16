{ lib
, black
, boto3
, buildPythonPackage
<<<<<<< HEAD
, cryptography
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, isort
, jinja2
, md-toc
, mdformat
, newversion
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
<<<<<<< HEAD
  version = "7.19.0";
=======
  version = "7.14.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Wczk1DNoOpvd7efnZFUf4FSjYqHdkMKMNwNVeQOPeEg=";
=======
    hash = "sha256-T8BIfopprCfcOpv92soTD3S4eYoAdT70pSMSHlFbBuE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    black
    boto3
<<<<<<< HEAD
    cryptography
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    isort
    jinja2
    md-toc
    mdformat
    newversion
    pyparsing
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mypy_boto3_builder"
  ];

  disabledTests = [
    # Tests require network access
    "TestBotocoreChangelogChangelog"
  ];

  meta = with lib; {
    description = "Type annotations builder for boto3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
