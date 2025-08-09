{
  lib,
  aioboto3,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pythonOlder,
  redis,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "5.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    tag = "v${version}";
    hash = "sha256-OWaGjH9FKv5FOG6ttoT+zvLKcrD4j6y1cSpArtCEn4w=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "boto3" ];

  dependencies = [
    aioboto3
    orjson
    redis
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.core" ];

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      chivay
      fab
    ];
  };
}
