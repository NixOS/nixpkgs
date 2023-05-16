{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jmp";
<<<<<<< HEAD
  version = "0.0.4";
=======
  # As of 2022-01-01, the latest stable version (0.0.2) fails tests with recent JAX versions,
  # IIUC it's fixed in https://github.com/deepmind/jmp/commit/4969392f618d7733b265677143d8c81e44085867
  version = "unstable-2021-10-03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-+PefZU1209vvf1SfF8DXiTvKYEnZ4y8iiIr8yKikx9Y=";
=======
    rev = "260e5ba01f46b10c579a61393e6c7e546aeae93e";
    hash = "sha256-BTHy/jNf6LeV+x3GTI9MDBWLK6A5z2Z1TQyBkHMTeuE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Wheel requires only `numpy`, but the import needs `jax`.
  propagatedBuildInputs = [
    jax
  ];

  pythonImportsCheck = [
    "jmp"
  ];

  nativeCheckInputs = [
    jaxlib
    pytestCheckHook
  ];

  meta = with lib; {
    description = "This library implements support for mixed precision training in JAX.";
    homepage = "https://github.com/deepmind/jmp";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
