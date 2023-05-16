{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hatch-vcs
, hatchling
, pytest-lazy-fixture
, pytestCheckHook
, pythonOlder
, wcwidth
=======
, pythonOlder
, hatch-vcs
, hatchling
, wcwidth
, importlib-metadata
, pytest-lazy-fixture
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "prettytable";
<<<<<<< HEAD
  version = "3.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash= "sha256-JnxUjUosQJgprIbA9szSfw1Fi21Qc4WljoRAQv4x5YM=";
=======
    hash= "sha256-J6oWNug2MEkUZSi67mM5H/Nf4tdSTB/ku34plp1XWCM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    wcwidth
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prettytable"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
=======
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
