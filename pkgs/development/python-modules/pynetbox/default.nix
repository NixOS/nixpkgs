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
  version = "7.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "pynetbox";
    tag = "v${version}";
    hash = "sha256-h/kEMPr3l9ZhWNv4i4R58AQ7z4WdVbBM5Mq3X6Hnp88=";
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

  meta = {
    changelog = "https://github.com/netbox-community/pynetbox/releases/tag/v${version}";
    description = "API client library for Netbox";
    homepage = "https://github.com/netbox-community/pynetbox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
