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
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = "greeclimate";
    rev = "v${version}";
    hash = "sha256-Y8IgqrU8zzV020qwyyb57Tp2j7laQ3JsCOCYBuf8vsQ=";
  };

  postPatch = ''
    # upstream issue for proper solution https://github.com/cmroche/greeclimate/issues/46
    substituteInPlace setup.py \
      --replace 'name="greeclimate",' 'name="greeclimate",version="${version}",'
  '';

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
