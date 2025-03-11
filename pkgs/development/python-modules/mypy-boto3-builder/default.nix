{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # dependencies
  boto3,
  botocore,
  jinja2,
  loguru,
  mdformat,
  packaging,
  prompt-toolkit,
  questionary,
  requests,
  ruff,
  setuptools,

  # tests
  pytest-mock,
  pytestCheckHook,
  requests-mock,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "8.9.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    tag = version;
    hash = "sha256-5BWwCEf1kz3l04b+nkPlX6fMUxTdBVyj7pYlAHqD02o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "8.9.1"' 'version = "${version}"'
  '';

  dependencies = [
    boto3
    botocore
    jinja2
    loguru
    mdformat
    packaging
    prompt-toolkit
    questionary
    requests
    ruff
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  pythonImportsCheck = [ "mypy_boto3_builder" ];

  disabledTests = [
    # Tests require network access
    "TestBotocoreChangelogChangelog"
  ];

  meta = {
    description = "Type annotations builder for boto3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mypy_boto3_builder";
  };
}
