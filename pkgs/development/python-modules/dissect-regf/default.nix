{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-regf";
<<<<<<< HEAD
  version = "3.7";
=======
  version = "3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.regf";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-WUrND1RnXTeN3WosR+m+yVJLe/imBTx7nmUZrSIc1E0=";
=======
    hash = "sha256-nF9vJACNPA5QQy+nWjkkAoVAVdrlzAgKq//ldWpVtlE=";
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
    "dissect.regf"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Windows registry file format";
    homepage = "https://github.com/fox-it/dissect.regf";
    changelog = "https://github.com/fox-it/dissect.regf/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
