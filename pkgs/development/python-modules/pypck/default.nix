{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pypck";
<<<<<<< HEAD
  version = "0.7.17";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.7.16";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Vlt4+fRULb9mB0ceRmc7MJ50DnF9DAJPHA8iCbNVvcE=";
  };

  patches = [
    # https://github.com/alengwenus/pypck/pull/109
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/alengwenus/pypck/commit/17023ebe8082120b1eec086842ca809ec6e9df2b.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    hash = "sha256-OcXMVgG62JUH28BGvfO/rpnC++/klhBLJ2HafDu9R40=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_connection_lost"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "pypck"
  ];

  meta = with lib; {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${version}";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
