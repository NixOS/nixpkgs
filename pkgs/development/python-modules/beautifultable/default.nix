{ lib
, buildPythonPackage
, fetchFromGitHub
, wcwidth
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beautifultable";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pri22296";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/SReCEvSwiNjBoz/3tGJ9zUNBAag4mLsHlUXwm47zCw=";
  };

  propagatedBuildInputs = [
    wcwidth
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test.py" ];

  pythonImportsCheck = [ "beautifultable" ];

  meta = with lib; {
    description = "Python package for printing visually appealing tables";
    homepage = "https://github.com/pri22296/beautifultable";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
