{ lib
, buildPythonPackage
<<<<<<< HEAD
, ciso8601
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, httpx
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "onvif-zeep-async";
<<<<<<< HEAD
  version = "3.1.12";
=======
  version = "3.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-TXSwrWnDXzntXZN/u09QB3BsIa6tpf6LpGFKEyA/GH8=";
  };

  propagatedBuildInputs = [
    ciso8601
=======
    hash = "sha256-Lq8jYLEJKluRfsuRghkp7VPIcrHn3qaJTyid9O8lriA=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    httpx
    zeep
  ];

  pythonImportsCheck = [
    "onvif"
  ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    description = "ONVIF Client Implementation in Python";
    homepage = "https://github.com/hunterjm/python-onvif-zeep-async";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
