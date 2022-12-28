{ lib
, pycryptodome
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cart";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CybercentreCanada";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PsdDlNhX0FbuwS5ZXk9P98DjnzDGdigfnRwrdwYa4qY=";
  };

  propagatedBuildInputs = [
    pycryptodome
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "unittests"
  ];

  pythonImportsCheck = [
    "cart"
  ];

  meta = with lib; {
    description = "Python module for the CaRT Neutering format";
    homepage = "https://github.com/CybercentreCanada/cart";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
