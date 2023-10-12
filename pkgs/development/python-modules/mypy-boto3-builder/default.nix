{ lib
, black
, boto3
, buildPythonPackage
, cryptography
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
  version = "7.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    rev = "refs/tags/${version}";
    hash = "sha256-Wczk1DNoOpvd7efnZFUf4FSjYqHdkMKMNwNVeQOPeEg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    black
    boto3
    cryptography
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
