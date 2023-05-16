{ lib
, buildPythonPackage
, fetchFromGitHub
, flaky
, hatch-vcs
, hatchling
, httpx
, importlib-metadata
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylast";
<<<<<<< HEAD
  version = "5.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pylast";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6yxsqruosSOJ5LeIBbvuEko4s9qU/ObNZiJD5YH/hvY=";
=======
    hash = "sha256-LRZYLo9h7Z8WXemLgKR5qzAmtL4x/AQQJpta3e0WHcc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flaky
  ];

  pythonImportsCheck = [
    "pylast"
  ];

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab rvolosatovs ];
  };
}
