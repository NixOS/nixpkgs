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
  version = "2.2.0-unstable-2025-02-18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "proxmoxer";
    repo = "proxmoxer";
    rev = "cf1bcde696537c74ef00d8e71fb86735fb4c2c79";
    hash = "sha256-h5Sla7/4XiZSGwKstyiqs/T2Qgi13jI9YMVPqDcF3sA=";
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

  meta = with lib; {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    changelog = "https://github.com/proxmoxer/proxmoxer/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
