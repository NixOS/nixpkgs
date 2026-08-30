{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

buildPythonPackage (finalAttrs: {
  pname = "model-hosting-container-standards";
  version = "0.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "model-hosting-container-standards";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bEL2CKJ4IryacurRmSe5nGGHTMIkSegSlbDciAGL6VI=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  patches = [
    # Upstream PR: https://github.com/aws/model-hosting-container-standards/pull/63
    (fetchpatch {
      name = "fix-compat-with-fastapi-0.137.patch";
      url = "https://github.com/aws/model-hosting-container-standards/commit/ce3f9590088e3194d56345074c65ae96524fb127.patch";
      hash = "sha256-H0oxuIOoGthN+JdXQmeJ/9PRwrfhBUnVEj0ASwgtztQ=";
      stripLen = 1;
    })
  ];

  build-system = [
    poetry-core
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

  disabledTestPaths = [
    # Runs `pip install`
    "tests/integration/test_dependency_install_integration.py"
  ];

  meta = {
    description = "Standardized Python framework for seamless integration between ML frameworks (TensorRT-LLM, vLLM) and Amazon SageMaker hosting";
    homepage = "https://github.com/aws/model-hosting-container-standards/tree/main/python";
    changelog = "https://github.com/aws/model-hosting-container-standards/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
