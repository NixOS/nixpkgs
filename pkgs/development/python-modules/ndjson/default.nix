<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, six
, watchdog
}:
=======
{ lib, buildPythonPackage, fetchPypi, watchdog, flake8
, pytest, pytest-runner, coverage, sphinx, twine }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "ndjson";
  version = "0.3.1";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v5dGy2uxy1PRcs2n8VTAfHhtZl/yg0Hk5om3lrIp5dY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    six
    watchdog
  ];

  pythonImportsCheck = [
    "ndjson"
  ];

  meta = with lib; {
    description = "Module supports ndjson";
    homepage = "https://github.com/rhgrant10/ndjson";
    changelog = "https://github.com/rhgrant10/ndjson/blob/v${version}/HISTORY.rst";
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "v5dGy2uxy1PRcs2n8VTAfHhtZl/yg0Hk5om3lrIp5dY=";
  };

  nativeCheckInputs = [ pytest pytest-runner flake8 twine sphinx coverage watchdog ];

  meta = with lib; {
    homepage = "https://github.com/rhgrant10/ndjson";
    description = "JsonDecoder";
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ freezeboy ];
  };
}
