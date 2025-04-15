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
  version = "5.29.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    tag = "v${version}";
    hash = "sha256-9dDEEjY9ajh/eMuXTLkLVSGb38TOi3RDmRIf2vKknkI=";
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
