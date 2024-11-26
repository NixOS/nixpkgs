{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  pytestCheckHook,

  # downstream dependencies
  localstack,
}:

buildPythonPackage rec {
  pname = "localstack-client";
  version = "1.39";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack-python-client";
    # Request for proper tags: https://github.com/localstack/localstack-python-client/issues/38
    rev = "f1e538ad23700e5b1afe98720404f4801475e470";
    hash = "sha256-MBXTiTzCwkduJPPRN7OKaWy2q9J8xCX/GGu09tyac3A=";
  };

  propagatedBuildInputs = [ boto3 ];

  pythonImportsCheck = [ "localstack_client" ];

  # All commands test `localstack` which is a downstream dependency
  doCheck = false;
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Has trouble creating a socket
    "test_session"
  ];

  # For tests
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit localstack;
  };

  meta = with lib; {
    description = "Lightweight Python client for LocalStack";
    homepage = "https://github.com/localstack/localstack-python-client";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
