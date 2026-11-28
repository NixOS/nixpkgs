{
  lib,
  aioboto3,
  boto3,
  buildPythonPackage,
  cryptography,
  fastapi,
  fetchFromGitHub,
  httpx2,
  orjson,
  pydantic,
  pyjwt,
  redis,
  setuptools,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "karton-core";
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/IV7G6Lim7h9rFr073g7SBGbK/tCA0MNaVfYC+a6S98=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "aioboto3"
    "boto3"
  ];

  dependencies = [
    aioboto3
    boto3
    cryptography
    fastapi
    httpx2
    orjson
    pydantic
    pyjwt
    redis
    websockets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "karton.core" ];

  disabledTestPaths = [
    # End-to-end tests are disabled
    "tests/e2e/"
  ];

  meta = {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      chivay
      fab
    ];
  };
})
