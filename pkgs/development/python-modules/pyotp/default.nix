{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyotp";
<<<<<<< HEAD
  version = "2.9.0";
=======
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NGtmQuDb3eO0/1qTC2ZMqCq/oRY1btSMxCx9ZZDTb2M=";
=======
    hash = "sha256-wvXhfZ2pLY7B995jMasIEWuRFa26vLpuII1G/EmpjFo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    changelog = "https://github.com/pyauth/pyotp/blob/v${version}/Changes.rst";
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
