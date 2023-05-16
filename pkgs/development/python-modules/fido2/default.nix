{ lib
, buildPythonPackage
<<<<<<< HEAD
, cryptography
, fetchPypi
, mock
, poetry-core
, pyfakefs
, pythonOlder
, six
=======
, fetchPypi
, poetry-core
, six
, cryptography
, mock
, pyfakefs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "fido2";
<<<<<<< HEAD
  version = "1.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YRDZExBvdhmSAbMtJisoV1YsxGuh0LnFH7zjDck2xXM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    six
  ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
    pyfakefs
  ];

  unittestFlagsArray = [
    "-v"
  ];

  pythonImportsCheck = [
    "fido2"
  ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB";
    homepage = "https://github.com/Yubico/python-fido2";
    changelog = "https://github.com/Yubico/python-fido2/releases/tag/${version}";
=======
  version = "1.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XcSVyoxZwcM3ODtLjDFNRrktXG/GUOcZhMbX+VQHn8M=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ six cryptography ];

  nativeCheckInputs = [ unittestCheckHook mock pyfakefs ];

  unittestFlagsArray = [ "-v" ];

  pythonImportsCheck = [ "fido2" ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = "https://github.com/Yubico/python-fido2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
