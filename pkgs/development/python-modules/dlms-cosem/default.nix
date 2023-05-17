{ lib
, asn1crypto
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyserial
, pytestCheckHook
, python-dateutil
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dlms-cosem";
  version = "21.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pwitab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BrLanP+SIRRof15yzqwcDOxw92phbW7m9CfORz0xo7I=";
  };

  propagatedBuildInputs = [
    asn1crypto
    attrs
    cryptography
    pyserial
    python-dateutil
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dlms_cosem"
  ];

  meta = with lib; {
    description = "Python module to parse DLMS/COSEM";
    homepage = "https://github.com/pwitab/dlms-cosem";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
