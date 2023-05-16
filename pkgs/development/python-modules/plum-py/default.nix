{ lib
<<<<<<< HEAD
, baseline
, buildPythonPackage
, fetchFromGitLab
, pytestCheckHook
, pythonOlder
=======
, buildPythonPackage
, fetchFromGitLab
, isPy3k
, pytestCheckHook
, baseline
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "plum-py";
<<<<<<< HEAD
  version = "0.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.8.5";
  disabled = !isPy3k;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "dangass";
    repo = "plum";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-gZSRqijKdjqOZe1+4aeycpCPsh6HC5sRbyVjgK+g4wM=";
=======
    rev = version;
    hash = "sha256-jCZUNT1HpSr0khHsjnxEzN2LCzcDV6W27PjVkwFJHUg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i "/python_requires =/d" setup.cfg
  '';

<<<<<<< HEAD
=======
  pythonImportsCheck = [ "plum" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    baseline
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "plum"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "Classes and utilities for packing/unpacking bytes";
<<<<<<< HEAD
    homepage = "https://plum-py.readthedocs.io/";
    changelog = "https://gitlab.com/dangass/plum/-/blob/${version}/docs/release_notes.rst";
=======
    homepage = "https://plum-py.readthedocs.io/en/latest/index.html";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
