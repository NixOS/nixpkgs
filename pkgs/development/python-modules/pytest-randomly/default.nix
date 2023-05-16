{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchFromGitHub
, importlib-metadata
, numpy
, pytest-xdist
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
<<<<<<< HEAD
  version = "3.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-bxbW22Nf/0hfJYSiz3xdrNCzrb7vZwuVvSIrWl0Bkv4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-n/Xp/HghqcQUreez+QbR3Mi5hE1U4zoOJCdFqD+pVBk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    factory_boy
    faker
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  # needs special invocation, copied from tox.ini
  pytestFlagsArray = [
    "-p"
    "no:randomly"
  ];

  pythonImportsCheck = [
    "pytest_randomly"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/pytest-dev/pytest-randomly/blob/${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
