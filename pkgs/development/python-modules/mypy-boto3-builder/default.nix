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
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  ruff,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "8.8.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    tag = version;
    hash = "sha256-aDQ+zznHS0EyanmasT1wOtw0jgo6SYGlR6132XXmqTc=";
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
    ruff
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-mock
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mypy_boto3_builder" ];

  disabledTests = [
    # Tests require network access
    "TestBotocoreChangelogChangelog"
  ];

  meta = with lib; {
    description = "Type annotations builder for boto3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${src.tag}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "mypy_boto3_builder";
  };
}
