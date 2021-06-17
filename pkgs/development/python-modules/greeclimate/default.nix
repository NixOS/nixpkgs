{ lib
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
  version = "0.11.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = version;
    sha256 = "1n46klbhl0gpd5x995mrcr1qfd77hrfm501qns1zhvv0zk8mdsf4";
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
    description = "Discover, connect and control Gree based minisplit systems";
    homepage = "https://github.com/cmroche/greeclimate";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
