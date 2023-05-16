{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython
, poetry-core
, setuptools

# propagates
, cryptography

# tests
, pytestCheckHook
}:

let
  pname = "chacha20poly1305-reuseable";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RBXEumw5A/XzB/LazUcvq8JM/Ahvcy9lCTYKpGcY7go=";
=======
    hash = "sha256-T5mmHUMNbdvexeSaIDZIm/3yQcDKnWdor9IK63FE0no=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  pythonImportsCheck = [
    "chacha20poly1305_reuseable"
  ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=chacha20poly1305_reuseable --cov-report=term-missing:skip-covered" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ChaCha20Poly1305 that is reuseable for asyncio";
    homepage = "https://github.com/bdraco/chacha20poly1305-reuseable";
    changelog = "https://github.com/bdraco/chacha20poly1305-reuseable/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
