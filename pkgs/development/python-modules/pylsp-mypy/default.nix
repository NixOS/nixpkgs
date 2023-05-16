{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
<<<<<<< HEAD
, tomli
=======
, toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
<<<<<<< HEAD
  version = "0.6.7";
  format = "pyproject";
=======
  version = "0.6.6";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "python-lsp";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-ZsNIw0xjxnU9Ue0C7TlhzVOCOCKEbCa2CsiiqeMb14I=";
  };

  patches = [
    # https://github.com/python-lsp/pylsp-mypy/pull/64
    (fetchpatch {
      name = "fix-hanging-test.patch";
      url = "https://github.com/python-lsp/pylsp-mypy/commit/90d28edb474135007804f1e041f88713a95736f9.patch";
      hash = "sha256-3DVyUXVImRemXCuyoXlYbPJm6p8OnhBdEKmwjx88ets=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    mypy
    python-lsp-server
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
=======
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-9B+GSEoQEqd1W/g0oup4xULKWOF0TgSG5DfBtyWA3vs=";
  };

  propagatedBuildInputs = [
    mypy
    python-lsp-server
    toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylsp_mypy"
  ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = with lib; {
    description = "Mypy plugin for the Python LSP Server";
<<<<<<< HEAD
    homepage = "https://github.com/python-lsp/pylsp-mypy";
=======
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
