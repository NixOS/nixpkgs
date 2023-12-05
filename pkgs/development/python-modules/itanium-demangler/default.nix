{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "itanium-demangler";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "python-itanium_demangler";
    rev = "refs/tags/v${version}";
    hash = "sha256-I6NUfckt2cocQt5dZSFadpshTCuA/6bVNauNXypWh+A=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  pythonImportsCheck = [
    "itanium_demangler"
  ];

  meta = with lib; {
    description = "Python parser for the Itanium C++ ABI symbol mangling language";
    homepage = "https://github.com/whitequark/python-itanium_demangler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fab pamplemousse ];
  };
}
