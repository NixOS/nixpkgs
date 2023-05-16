{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvmomi";
<<<<<<< HEAD
  version = "8.0.1.0.2";
=======
  version = "8.0.0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-NI2xkHo9A9zEvdbTt9vF91gavSnCuFjdjr6PxEvkSZM=";
=======
    hash = "sha256-t54FUgEXEUpb3SqayY7gCmj1egavIaoXMfuShDL9dBo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
