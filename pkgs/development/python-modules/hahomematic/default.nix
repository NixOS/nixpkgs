{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, orjson
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, voluptuous
, websocket-client
, xmltodict
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "hahomematic";
<<<<<<< HEAD
  version = "2023.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "2023.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-FM07+ORPFne+9gtruuKqp2EwPLF9py7zi9a6vehN2Yk=";
=======
    hash = "sha256-4isf3U4Wp5FCQ0zVfmDLK+zkq/IXLFZhiaL6AYRXaRY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  # Starting with 0.30 the tests are broken, check with the next major release
  doCheck = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    changelog = "https://github.com/danielperna84/hahomematic/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
