{ lib
, astroid
, buildPythonPackage
, fetchFromGitHub
, packaging
, poetry-core
, poetry-semver
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "requirements-detector";
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-qmrHFQRypBJOI1N6W/Dtc5ss9JGqoPhFlbqrLHcb6vc=";
=======
    rev = version;
    hash = "sha256-H+h/PN1TrlpDRgI7tMWUhXlxj4CChwcxIR/BvyO261c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    astroid
    packaging
    poetry-semver
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "requirements_detector"
  ];

  meta = with lib; {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
<<<<<<< HEAD
    changelog = "https://github.com/landscapeio/requirements-detector/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
