{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eradicate";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ikiqNe1a+OeRraNBbtAx6v3LsTajWlgxm4wR2Tcbmjk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "eradicate"
  ];

  pytestFlagsArray = [
    "test_eradicate.py"
  ];

  meta = with lib; {
    description = "Library to remove commented-out code from Python files";
    homepage = "https://github.com/myint/eradicate";
    changelog = "https://github.com/wemake-services/eradicate/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
