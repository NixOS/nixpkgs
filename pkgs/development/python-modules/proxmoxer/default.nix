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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-phCeJkiY8XxaD4VQCxOzoInkwWQzHU7ZGdHvxNVgifU=";
  };

  propagatedBuildInputs = [
    paramiko
    requests
  ];

  checkInputs = [
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
