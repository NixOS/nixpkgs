{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-esedb";
<<<<<<< HEAD
  version = "3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.esedb";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-OW0HqKQDg15fO/ETNv+cIupfsX53+qopMoZZ/3xcAUI=";
=======
    hash = "sha256-RBU+aQbqPfF7kjt5Nc3+FnrmkTZgGyUv1HFTFP4ZgZ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.esedb"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Microsofts Extensible Storage Engine Database (ESEDB)";
    homepage = "https://github.com/fox-it/dissect.esedb";
    changelog = "https://github.com/fox-it/dissect.esedb/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
