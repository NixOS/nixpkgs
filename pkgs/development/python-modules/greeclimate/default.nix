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
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = "v${version}";
    hash = "sha256-z8X/AZx5Vam7nqYTjhhyXz7E23Crf5vLlNhWXLGSMcs=";
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
