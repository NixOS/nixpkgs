{
  lib,
  buildPythonPackage,
  fetchPypi,
  boto3,
  pytestCheckHook,

  # use for testing promoted localstack
  pkgs,
}:

buildPythonPackage rec {
  pname = "localstack-client";
  version = "2.11";
  format = "setuptools";

  src = fetchPypi {
    pname = "localstack_client";
    inherit version;
    hash = "sha256-HL178fA7m1U//n6hD+E39E6NaQo3r5xlFeumGiN5/EY=";
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
    inherit (pkgs) localstack;
  };

  meta = {
    description = "Lightweight Python client for LocalStack";
    homepage = "https://github.com/localstack/localstack-python-client";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
