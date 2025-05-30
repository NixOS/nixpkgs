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
  version = "7.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "pynetbox";
    tag = "v${version}";
    hash = "sha256-gDcTWXGE0GOEmuDSwFgKytCidg8Py1PFMfJCDhuOMoQ=";
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
