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
  version = "2.12";
  format = "setuptools";

  src = fetchPypi {
    pname = "localstack_client";
    inherit version;
    hash = "sha256-27mHEv0siGnV3+16LKAGuVx3UP6aQ68SPvBU78fn67Q=";
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
