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
  version = "2.7";
  format = "setuptools";

  src = fetchPypi {
    pname = "localstack_client";
    inherit version;
    hash = "sha256-FJkxGZAaS8vvfDLYmbJPSliodaZ2VpPt8QZNZrimhAg=";
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

  meta = with lib; {
    description = "Lightweight Python client for LocalStack";
    homepage = "https://github.com/localstack/localstack-python-client";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
