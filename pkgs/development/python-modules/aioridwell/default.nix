{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, freezegun
, poetry-core
, pyjwt
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, titlecase
, types-pytz
}:

buildPythonPackage rec {
  pname = "aioridwell";
<<<<<<< HEAD
  version = "2023.08.0";
=======
  version = "2023.01.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-AreQC5LOthnOEj0HnEww4zLob394XwCvqZBwjsT2Lcg=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aioridwell/pull/234
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aioridwell/commit/79a9dd7462dcfeb0833abca73a1f184827120a6f.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

=======
    hash = "sha256-enNYzU65QBT/ryCUNwB08U+QiFvVb03fbYzZ5Qk6GTk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pyjwt
    pytz
    titlecase
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  disabledTests = [
    # AssertionError: assert datetime.date(...
    "test_get_next_pickup_event"
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "aioridwell"
  ];

  meta = with lib; {
    description = "Python library for interacting with Ridwell waste recycling";
    homepage = "https://github.com/bachya/aioridwell";
    changelog = "https://github.com/bachya/aioridwell/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
