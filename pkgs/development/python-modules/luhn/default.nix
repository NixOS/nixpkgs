{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "luhn";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mmcloughlin";
    repo = pname;
    rev = version;
    hash = "sha256-ZifaCjOVhWdXuzi5n6V+6eVN5vrEHKgUdpSOXoMyR18=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "luhn"
  ];

  meta = with lib; {
    description = "Python module for generate and verify Luhn check digits";
    homepage = "https://github.com/mmcloughlin/luhn";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
