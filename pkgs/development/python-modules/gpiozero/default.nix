{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx-rtd-theme
, sphinxHook
, colorzero
, mock
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "1.6.2";
  format = "setuptools";

<<<<<<< HEAD
  disabled = pythonOlder "3.7";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "gpiozero";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dmFc3DNTlEajYQ5e8QK2WfehwYwAsWyG2cxKg5ykEaI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    colorzero
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "gpiozero"
    "gpiozero.tools"
  ];

<<<<<<< HEAD
  disabledTests = [
    # https://github.com/gpiozero/gpiozero/issues/1087
    "test_spi_hardware_write"
  ];

  meta = with lib; {
    description = "A simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
    changelog = "https://github.com/gpiozero/gpiozero/blob/v${version}/docs/changelog.rst";
=======
  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];


  meta = with lib; {
    description = "A simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
