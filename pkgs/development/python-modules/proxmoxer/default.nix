{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paramiko,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-toolbelt,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "proxmoxer";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "proxmoxer";
    repo = "proxmoxer";
    rev = "refs/tags/${version}";
    hash = "sha256-bwNv9eBuatMAWZ/ZOoF4VUZFIYAxJDEEwGQaAwPWcHY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    paramiko
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-toolbelt
    responses
  ];

  disabledTestPaths = [
    # Tests require openssh_wrapper which is outdated and not available
    "tests/test_openssh.py"
  ];

  disabledTests = [
    # Tests require openssh_wrapper which is outdated and not available
    "test_repr_openssh"
  ];

  pythonImportsCheck = [ "proxmoxer" ];

  meta = with lib; {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    changelog = "https://github.com/proxmoxer/proxmoxer/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
