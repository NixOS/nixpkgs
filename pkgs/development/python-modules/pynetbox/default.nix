{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  requests,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pynetbox";
  version = "7.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "pynetbox";
    rev = "refs/tags/v${version}";
    hash = "sha256-pP4DEHf4Dj3sQ7qx7tU0B0PaMCuzUM9R2pIYRI1Fpso=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    requests
  ];

  pythonImportsCheck = [ "pynetbox" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  disabledTestPaths = [
    # requires docker for integration test
    "tests/integration"
  ];

  meta = with lib; {
    changelog = "https://github.com/netbox-community/pynetbox/releases/tag/v${version}";
    description = "API client library for Netbox";
    homepage = "https://github.com/netbox-community/pynetbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
