<<<<<<< HEAD
{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, absl-py
, cloudpickle
, dm-tree
, jax
, jaxlib
, numpy
, pytestCheckHook
, toolz
, typing-extensions
=======
{ absl-py
, buildPythonPackage
, cloudpickle
, dm-tree
, fetchFromGitHub
, jax
, jaxlib
, lib
, numpy
, pytestCheckHook
, toolz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "chex";
<<<<<<< HEAD
  version = "0.1.82";
  format = "setuptools";

  disabled = pythonOlder "3.9";

=======
  version = "0.1.6";
  format = "setuptools";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-xBq22AaR2Tp1NSPefEyvCDeUYqRZlAf5LVHWo0luiXk=";
=======
    hash = "sha256-VolRlLLgKga9S17ByVrYya9VPtu9yiOnvt/WmlE1DOc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    absl-py
<<<<<<< HEAD
    jaxlib
    jax
    numpy
    toolz
    typing-extensions
=======
    cloudpickle
    dm-tree
    jax
    numpy
    toolz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "chex"
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    cloudpickle
    dm-tree
    pytestCheckHook
  ];

=======
    jaxlib
    pytestCheckHook
  ];

  disabledTests = [
    # See https://github.com/deepmind/chex/issues/204.
    "test_uninspected_checks"

    # These tests started failing at some point after upgrading to 0.1.5
    "test_useful_failure"
    "TreeAssertionsTest"
    "PmapFakeTest"
    "WithDeviceTest"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Chex is a library of utilities for helping to write reliable JAX code.";
    homepage = "https://github.com/deepmind/chex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
