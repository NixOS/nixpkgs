{ lib
, aiohttp
, aresponses
<<<<<<< HEAD
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
=======
, async-timeout
, attrs
, buildPythonPackage
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "py17track";
  version = "2021.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-T0Jjdu6QC8rTqZwe4cdsBbs0hQXUY6CkrImCgYwWL9o=";
  };

<<<<<<< HEAD
  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/py17track/pull/80
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/py17track/commit/3b52394759aa50c62e2a56581e30cdb94003e2f1.patch";
      hash = "sha256-iLgklhEZ61rrdzQoO6rp1HGZcqLsqGNitwIiPNLNHQ4=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
<<<<<<< HEAD
=======
    async-timeout
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    attrs
    pytz
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'attrs = ">=19.3,<21.0"' 'attrs = ">=19.3,<22.0"' \
      --replace 'async-timeout = "^3.0.1"' 'async-timeout = ">=3.0.1,<5.0.0"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "py17track"
  ];

  meta = with lib; {
    description = "Python library to track package info from 17track.com";
    homepage = "https://github.com/bachya/py17track";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
