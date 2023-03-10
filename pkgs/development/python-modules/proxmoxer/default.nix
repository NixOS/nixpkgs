{ lib
, buildPythonPackage
, fetchFromGitHub
, paramiko
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, responses
}:

buildPythonPackage rec {
  pname = "proxmoxer";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kwD6yJhVTaVAAUVA6k4r6HZy4w+MPDF7DfJBS8wGE/c=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "proxmoxer"
  ];

  meta = with lib; {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    changelog = "https://github.com/proxmoxer/proxmoxer/releases/tag/${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
