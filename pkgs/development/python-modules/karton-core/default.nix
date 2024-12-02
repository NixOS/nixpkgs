{
  lib,
  boto3,
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
  version = "5.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    hash = "sha256-KaEXBNGcJN88gIv7suKcr1pK4ih/QbByxEy3nZFlIgk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boto3
    orjson
    redis
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.core" ];

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      chivay
      fab
    ];
  };
}
