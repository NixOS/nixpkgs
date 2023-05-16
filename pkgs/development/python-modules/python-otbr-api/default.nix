{ lib
, aiohttp
, bitstruct
, buildPythonPackage
, cryptography
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, pytest-asyncio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, setuptools
, voluptuous
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "python-otbr-api";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-bPN2h60ypjlKpXs1xDS7bZcGRXvatA3EdlAX/HLxxTM=";
  };

  patches = [
    # https://github.com/home-assistant-libs/python-otbr-api/pull/68
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/home-assistant-libs/python-otbr-api/commit/37eb19c12d17ac7d040ded035d8401def872fbda.patch";
      hash = "sha256-JGsaLQNbUfz0uK/MeGnR2XTJDs4RnTOEg7BavfDPArg=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
=======
    hash = "sha256-0JPniehl4cnoTWgqmq1fMZwU8FFl2Zx4CF81az6iaxQ=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    aiohttp
    bitstruct
    cryptography
    voluptuous
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    pytest-asyncio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "python_otbr_api"
  ];

  meta = with lib; {
    description = "Library for the Open Thread Border Router";
    homepage = "https://github.com/home-assistant-libs/python-otbr-api";
    changelog = "https://github.com/home-assistant-libs/python-otbr-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
