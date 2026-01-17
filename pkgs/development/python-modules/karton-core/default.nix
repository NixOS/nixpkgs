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
  version = "5.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    tag = "v${version}";
    hash = "sha256-m7A7Fbl6VZtgR4+FhmV2T+K6kgHRNtdeyin1uhvw04U=";
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
