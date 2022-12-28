{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    hash = "sha256-0B2u2xnrGc3iQ8B9iAQ3fcovQQCPqdFsn5evgdDwg5M=";
  };

  propagatedBuildInputs = [
    boto3
    redis
  ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "karton.core"
  ];

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chivay fab ];
  };
}
