{ lib
, buildPythonPackage
, click
, click-log
, fetchFromGitHub
, pure-pcapy3
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "bellows";
<<<<<<< HEAD
  version = "0.36.3";
=======
  version = "0.35.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-5s2I24gvHRXHm7ZTNZxc6ge9Kbe6UObcY29SvbIUWJg=";
=======
    hash = "sha256-I9PXFdRXHQ7OnzCdB631nlfnkpConl+j5Z3iiH7RcA4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [
    "bellows"
  ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
