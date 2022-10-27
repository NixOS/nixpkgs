{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, paramiko
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "proxmoxer";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FY0JLDBoKmh85VoKh3UuPPRbMAIjs3l/fZM4owniH1c=";
  };

  propagatedBuildInputs = [
    paramiko
    requests
  ];

  checkInputs = [
    mock
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Tests require openssh_wrapper which is outdated and not available
    "tests/paramiko_tests.py"
  ];

  pythonImportsCheck = [
    "proxmoxer"
  ];

  meta = with lib; {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
