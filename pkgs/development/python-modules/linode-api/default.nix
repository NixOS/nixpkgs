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
  version = "5.28.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # Sources from Pypi exclude test fixtures
  src = fetchFromGitHub {
    owner = "linode";
    repo = "python-linode-api";
    tag = "v${version}";
    hash = "sha256-NTI/T78/D95sgVugjrsRKEPxU2jArvRcKiuD+09tKCo=";
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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ glenns ];
  };
}
