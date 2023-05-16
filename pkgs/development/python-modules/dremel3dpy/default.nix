{ lib
, async-timeout
, buildPythonPackage
<<<<<<< HEAD
, decorator
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, imageio
, imutils
, pythonOlder
, requests
, urllib3
, tqdm
, validators
, yarl
}:

buildPythonPackage rec {
  pname = "dremel3dpy";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ioZwvbdPhO2kY10TqGR427mRUJBUZ5bmpiWVOV92OkI=";
  };

  propagatedBuildInputs = [
    async-timeout
<<<<<<< HEAD
    decorator
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    imageio
    imutils
    requests
    tqdm
    urllib3
    validators
    yarl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dremel3dpy"
  ];

  meta = with lib; {
    description = "Module for interacting with Dremel 3D printers";
    homepage = "https://github.com/godely/dremel3dpy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
