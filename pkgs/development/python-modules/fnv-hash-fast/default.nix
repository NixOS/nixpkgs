{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, poetry-core
, setuptools
, wheel
, fnvhash
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fnv-hash-fast";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "fnv-hash-fast";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vKv3Hfla+U1teYVB+w8ONj0Ur996noanbg6aaJ6S6+I=";
=======
    hash = "sha256-yApMUTO6Kq2YESGMpkU4/FlN57+hX0uQr2fGH7QIdUE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=fnv_hash_fast --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    fnvhash
  ];

  pythonImportsCheck = [
    "fnv_hash_fast"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fast version of fnv1a";
    homepage = "https://github.com/bdraco/fnv-hash-fast";
    changelog = "https://github.com/bdraco/fnv-hash-fast/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
