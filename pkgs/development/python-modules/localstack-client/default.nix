{ lib
, buildPythonPackage
, fetchFromGitHub
, boto3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "localstack-client";
  version = "1.36";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack-python-client";
    # Request for proper tags: https://github.com/localstack/localstack-python-client/issues/38
    rev = "92229c02c5b3cd0cef006e99c3d47db15aefcb4f";
    sha256 = "sha256-pbDpe/5o4YU/2UIi8YbhzhIlXigOb/M2vjW9DKcIxoI=";
  };

  propagatedBuildInputs = [
    boto3
  ];

  pythonImportsCheck = [
    "localstack_client"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Has trouble creating a socket
    "test_session"
  ];

  # For tests
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A lightweight Python client for LocalStack";
    homepage = "https://github.com/localstack/localstack-python-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
