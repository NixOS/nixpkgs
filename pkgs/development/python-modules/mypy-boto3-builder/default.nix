{
  lib,
  black,
  boto3,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  isort,
  jinja2,
  md-toc,
  mdformat,
  newversion,
  pip,
  poetry-core,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "7.25.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    rev = "refs/tags/${version}";
    hash = "sha256-DHGeljGY8NRndlcDqvK1Noud90wUQrkaS54489b/6RQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    black
    boto3
    cryptography
    isort
    jinja2
    md-toc
    mdformat
    newversion
    pip
    pyparsing
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mypy_boto3_builder" ];

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
    mainProgram = "mypy_boto3_builder";
  };
}
