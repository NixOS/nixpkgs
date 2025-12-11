{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  fastapi,
  httpx,
  jmespath,
  pydantic,
  starlette,
  supervisor,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "model-hosting-container-standards";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "model-hosting-container-standards";
    tag = "v${version}";
    hash = "sha256-iy7lPtMM2J/zC1TUB5Eydtesy4JsjWTjACNlDhfSPA8=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "starlette"
  ];
  pythonRemoveDeps = [
    # Declared as a runtime dependency, but not used in practice
    "setuptools"
  ];
  dependencies = [
    fastapi
    httpx
    jmespath
    pydantic
    starlette
    supervisor
  ];

  pythonImportsCheck = [ "model_hosting_container_standards" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: Server should have created restart log
    "test_continuous_restart_behavior"
    "test_startup_retry_limit"
  ];

  meta = {
    description = "Standardized Python framework for seamless integration between ML frameworks (TensorRT-LLM, vLLM) and Amazon SageMaker hosting";
    homepage = "https://github.com/aws/model-hosting-container-standards/tree/main/python";
    changelog = "https://github.com/aws/model-hosting-container-standards/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
