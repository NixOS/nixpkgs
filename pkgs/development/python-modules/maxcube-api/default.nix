{ lib
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
=======
, pythonAtLeast
, pythonOlder
, fetchFromGitHub
, unittestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "maxcube-api";
  version = "0.4.3";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hackercowboy";
    repo = "python-${pname}";
    rev = "V${version}";
    sha256 = "10k61gfpnqljf3p3qxr97xq7j67a9cr4ivd9v72hdni0znrbx6ym";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "license=license" "license='MIT'"
  '';

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "testSendRadioMsgClosesConnectionOnErrorAndRetriesIfReusingConnection"
    "testSendRadioMsgReusesConnection"
  ];
=======
  nativeCheckInputs = [ unittestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "maxcube"
    "maxcube.cube"
  ];

  meta = with lib; {
<<<<<<< HEAD
=======
    # Tests indicate lack of 3.11 compatibility
    broken = pythonAtLeast "3.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "eQ-3/ELV MAX! Cube Python API";
    homepage = "https://github.com/hackercowboy/python-maxcube-api";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
