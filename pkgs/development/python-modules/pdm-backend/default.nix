{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# propagates
, importlib-metadata

# tests
, editables
, git
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pdm-backend";
<<<<<<< HEAD
  version = "2.1.4";
=======
  version = "2.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-46HTamiy+8fiGVeviYqXsjwu+PEBE38y19cBVRc+zm0=";
  };

  env.PDM_BUILD_SCM_VERSION = version;

=======
    hash = "sha256-NMnb9DiW5xvfsI1nHFNIwvA/yH2boqe+WeD5re/ojAM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "pdm.backend"
  ];

  nativeCheckInputs = [
    editables
    git
    pytestCheckHook
    setuptools
  ];

<<<<<<< HEAD
  preCheck = ''
    unset PDM_BUILD_SCM_VERSION
  '';

  setupHook = ./setup-hook.sh;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
