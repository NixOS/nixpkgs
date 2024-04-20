{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
, redis
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "5.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    hash = "sha256-q12S80GZFyh7zU6iMeCkyIesMK8qXtZ1B69w8H5LpOU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    orjson
    redis
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "karton.core"
  ];

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    changelog = "https://github.com/CERT-Polska/karton/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chivay fab ];
  };
}
