{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paramiko,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  responses,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "proxmoxer";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "proxmoxer";
    repo = "proxmoxer";
    tag = finalAttrs.version;
    hash = "sha256-v/QqNCzkcYk2pqr9tTeyvEEeXt4nzqooHAQEIiJitZ4=";
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

    # Test fails randomly
    "test_timeout"
  ];

  pythonImportsCheck = [ "proxmoxer" ];

  meta = {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    changelog = "https://github.com/proxmoxer/proxmoxer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
