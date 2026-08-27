{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  requests,
  six,
  pyopenssl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "9.1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "pyvmomi";
    tag = "v${version}";
    hash = "sha256-r7knotP4vRX7LA3dsdUoCjzj6Z3TjMLEBs7BnRWSl0A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    six
  ];

  optional-dependencies = {
    sso = [
      lxml
      pyopenssl
    ];
  };

  # Requires old version of vcrpy
  doCheck = false;

  pythonImportsCheck = [
    "pyVim"
    "pyVmomi"
  ];

  meta = {
    description = "Python SDK for the VMware vSphere API that allows you to manage ESX, ESXi, and vCenter";
    homepage = "https://github.com/vmware/pyvmomi";
    changelog = "https://github.com/vmware/pyvmomi/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
