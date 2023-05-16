{ lib
, aiofile
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pbr
, httpx
, pycryptodome
, pyjwt
<<<<<<< HEAD
, pytest-asyncio
, pytestCheckHook
, python
, respx
, time-machine
, tzdata
=======
, pytestCheckHook
, respx
, time-machine
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bimmer-connected";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.13.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-cx22otbBCSFRTfr+wY1+k5kyX6h9mTQfRBfPw3rplzY=";
=======
    hash = "sha256-Cl1TxIwR90dJPe86lbULU2fYeM/KGCqQIqbQqjfAPtk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pbr
  ];

  PBR_VERSION = version;

  propagatedBuildInputs = [
    aiofile
    httpx
    pycryptodome
    pyjwt
  ];

<<<<<<< HEAD
  postInstall = ''
    cp -R bimmer_connected/tests/responses $out/${python.sitePackages}/bimmer_connected/tests/
  '';

  nativeCheckInputs = [
    pytest-asyncio
=======
  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    respx
    time-machine
  ];

<<<<<<< HEAD
  preCheck = ''
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "bimmer_connected"
  ];

  meta = with lib; {
    changelog = "https://github.com/bimmerconnected/bimmer_connected/releases/tag/${version}";
    description = "Library to read data from the BMW Connected Drive portal";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
