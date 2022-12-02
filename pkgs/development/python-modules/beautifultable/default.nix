{ lib
, buildPythonPackage
, fetchFromGitHub
, wcwidth
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beautifultable";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pri22296";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/SReCEvSwiNjBoz/3tGJ9zUNBAag4mLsHlUXwm47zCw=";
  };

  propagatedBuildInputs = [
    wcwidth
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "beautifultable"
  ];

  meta = with lib; {
    description = "Python package for printing visually appealing tables";
    homepage = "https://github.com/pri22296/beautifultable";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
