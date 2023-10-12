{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvmomi";
  version = "8.0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IoYxk/lS7dhw0q3kfpq7y/oDNmc1dOra0YA3CiHe8YM=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # Requires old version of vcrpy
  doCheck = false;

  pythonImportsCheck = [
    "pyVim"
    "pyVmomi"
  ];

  meta = with lib; {
    description = "Python SDK for the VMware vSphere API that allows you to manage ESX, ESXi, and vCenter";
    homepage = "https://github.com/vmware/pyvmomi";
    changelog = "https://github.com/vmware/pyvmomi/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
