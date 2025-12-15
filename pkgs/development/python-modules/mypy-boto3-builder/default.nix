{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  loguru,
  mdformat,
  packaging,
  prompt-toolkit,
  pytest-mock,
  pytestCheckHook,
  questionary,
  requests-mock,
  requests,
  ruff,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "mypy-boto3-builder";
  version = "8.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youtype";
    repo = "mypy_boto3_builder";
    tag = version;
    hash = "sha256-ZpZ//vFFxW1o9dEaCuO/8UHYM6lExvktYeNIiSrXR0Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "8.11.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

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

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "mypy_boto3_builder" ];

  disabledTests = [
    # Tests require network access
    "TestBotocoreChangelogChangelog"
  ];

  meta = {
    description = "Type annotations builder for boto3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mypy_boto3_builder";
  };
}
