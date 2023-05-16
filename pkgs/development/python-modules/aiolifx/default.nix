{ lib
, async-timeout
<<<<<<< HEAD
, click
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
<<<<<<< HEAD
, inquirerpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-oK8Ih62EFwu3X5PNVFLH+Uce6ZBs7IMXet5/DHxfd5M=";
=======
    hash = "sha256-NiNKFrWxpGkwbb7tFEDD5jZ6ETW20BBIqrdjCsL/DkY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    async-timeout
    bitstring
<<<<<<< HEAD
    click
    ifaddr
    inquirerpy
  ];

  # Module has no tests
=======
    ifaddr
  ];

  # tests are not implemented
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  pythonImportsCheck = [
    "aiolifx"
  ];

  meta = with lib; {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/frawau/aiolifx";
    changelog = "https://github.com/frawau/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
