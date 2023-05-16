{ lib
, aiohttp
, aioresponses
, asynccmd
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
<<<<<<< HEAD
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-gdIrbr25GXaX26B1f7u0NKbqqnAC2tmMFZspzW6I4HI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

=======
    hash = "sha256-Pjv8AxXuwi48Z8U+LSZZ+OhXrE3KlX7jlmnXTBLxXOs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    asynccmd
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python module for the SPC Web Gateway REST API";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
<<<<<<< HEAD
    changelog = "https://github.com/pyspcwebgw/pyspcwebgw/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
