{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
  polling,
  deprecated,
  pytestCheckHook,
  mock,
  httpretty,
}:

buildPythonPackage rec {
  pname = "linode-api";
  version = "5.29.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    tag = "v${version}";
    hash = "sha256-orMQr3FYyK4piazMsZmYkaZ/G/DvQOZObdtWt0wiEi4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    polling
    deprecated
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    httpretty
  ];

  disabledTestPaths = [
    # needs api token
    "test/integration"
  ];

  pythonImportsCheck = [ "linode_api4" ];

  meta = {
    description = "Python library for the Linode API v4";
    homepage = "https://github.com/linode/python-linode-api";
    changelog = "https://github.com/linode/linode_api4-python/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
