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
  version = "1.3.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-3EpId20WVVjXA/wxwy1peyHPcXdiT3fprABkcNBpZtE=";
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

  # Tests require openssh_wrapper which is outdated and not available
  pytestFlagsArray = [ "tests/paramiko_tests.py" ];
  pythonImportsCheck = [ "proxmoxer" ];

  meta = with lib; {
    description = "Python wrapper for Proxmox API v2";
    homepage = "https://github.com/proxmoxer/proxmoxer";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
