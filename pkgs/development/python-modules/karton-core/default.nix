{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    hash = "sha256-IhxMei6KkPsDnUkV4+zxSMI7rgZgOvbHQFqJAC1b5iw=";
  };

  propagatedBuildInputs = [
    boto3
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
