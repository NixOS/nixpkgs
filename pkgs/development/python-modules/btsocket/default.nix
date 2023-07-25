{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "btsocket";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ukBaz";
    repo = "python-btsocket";
    rev = "v${version}";
    hash = "sha256-IqlbFYbEyJPlcmT3DIQIwsjQEAGeIGRtFNx4jWwNtjE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "btsocket"
  ];

  meta = with lib; {
    description = "Library to interact with the Bluez Bluetooth Management API";
    homepage = "https://github.com/ukBaz/python-btsocket";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
