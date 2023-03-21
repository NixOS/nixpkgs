{ lib
, buildPythonPackage
, fetchFromGitHub
, libcec
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pycec";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "konikvranik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-H18petSiUdftZN8Q3fPmfSJA3OZks+gI+FAq9LwkRsk=";
  };

  propagatedBuildInputs = [
    libcec
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycec"
  ];

  meta = with lib; {
    description = "Python modules to access HDMI CEC devices";
    homepage = "https://github.com/konikvranik/pycec/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
