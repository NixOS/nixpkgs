{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itanium-demangler";
  version = "1.0"; # pulled from pypi version

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "python-itanium_demangler";
    rev = "29c77860be48e6dafe3496e4d9d0963ce414e366";
    hash = "sha256-3fXwHO8JZgE0QSWScMKgRKDX5380cYPSMNMKUgwtqWI=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  pythonImportsCheck = [
    " itanium_demangler "
  ];

  meta = with lib; {
    description = "Python parser for the Itanium C++ ABI symbol mangling language";
    homepage = "https://github.com/whitequark/python-itanium_demangler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
