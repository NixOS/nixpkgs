{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "gps3";
<<<<<<< HEAD
  version = "unstable-2017-11-01";

  src = fetchFromGitHub {
    owner = "wadda";
    repo = pname;
    rev = "91adcd7073b891b135b2a46d039ce2125cf09a09";
    hash = "sha256-sVK61l8YunKAGFTSAq/m5aUGFfnizwhqTYbdznBIKfk=";
=======
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "onkelbeh";
    repo = pname;
    rev = version;
    sha256 = "0a0qpk7d2b1cld58qcdn6bxrkil6ascs51af01dy4p83062h1hi6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "gps3" ];

  meta = with lib; {
    description = "Python client for GPSD";
<<<<<<< HEAD
    homepage = "https://github.com/wadda/gps3";
=======
    homepage = "https://github.com/onkelbeh/gps3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
