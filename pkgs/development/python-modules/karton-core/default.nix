{
  lib,
  aioboto3,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  redis,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "5.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    tag = "v${version}";
    hash = "sha256-b/wOkOk6LB8uTDsXJrNQ2iru2H6mgaMhIyWSU5y2mx0=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "aioboto3"
    "boto3"
  ];

  dependencies = [
    aioboto3
    orjson
    redis
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.core" ];

  meta = {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      chivay
      fab
    ];
  };
}
