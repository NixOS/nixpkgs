{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
<<<<<<< HEAD
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "3.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-v0giDdH6bYCSrotd9WGSlIMzylTz7FHeCE/JkCw7frY=";
=======
    hash = "sha256-f6cE1x7TsjJsdACLZjsbyfnTDPXcpXqs0qBo4l+fKS4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.cstruct"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    changelog = "https://github.com/fox-it/dissect.cstruct/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
