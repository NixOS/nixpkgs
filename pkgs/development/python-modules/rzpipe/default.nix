{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rzpipe";
<<<<<<< HEAD
  version = "0.6.0";
  format = "setuptools";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-py4oiNp+WUcOGHn2AdHyIpgV8BsI8A1gtJi2joi1Wxc=";
=======
    hash = "sha256-RSgBwmtpI58caRWov+cDWLKhti+7r70VxJbCxJveEiM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # No native rz_core library
  doCheck = false;

  pythonImportsCheck = [
    "rzpipe"
  ];

  meta = with lib; {
    description = "Python interface for rizin";
    homepage = "https://rizin.re";
<<<<<<< HEAD
    changelog = "https://github.com/rizinorg/rizin/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
