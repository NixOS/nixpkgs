{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, netifaces
, pycryptodome
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "greeclimate";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = "refs/tags/v${version}";
    hash = "sha256-DRVCBbGj0NfQBn9qNRc0Gu3LNO6KDNF1/ZdSAuhCVsM=";
  };

  propagatedBuildInputs = [
    netifaces
    pycryptodome
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "greeclimate"
    "greeclimate.device"
    "greeclimate.discovery"
    "greeclimate.exceptions"
    "greeclimate.network"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Discover, connect and control Gree based minisplit systems";
    homepage = "https://github.com/cmroche/greeclimate";
    changelog = "https://github.com/cmroche/greeclimate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
