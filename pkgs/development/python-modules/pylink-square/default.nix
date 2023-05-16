{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, fetchPypi
, mock
, psutil
, pytestCheckHook
, pythonOlder
, six
=======
, fetchPypi
, fetchFromGitHub
, mock
, psutil
, six
, future
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pylink-square";
<<<<<<< HEAD
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.0.0";

  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rcM7gvUUfXN5pL9uIihzmOCXA7NKjiMt2GaQaGJxD9M=";
  };

  propagatedBuildInputs = [
    psutil
    six
  ];
=======
    hash = "sha256-05mg2raHiKg0gHxF/7zFd81C/8OrhStThMwEnpaFGSc=";
  };

  propagatedBuildInputs = [ psutil six future ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "pylink"
  ];

  disabledTests = [
    # AttributeError: 'called_once_with' is not a valid assertion
    "test_cp15_register_write_success"
    "test_jlink_restarted"
    "test_set_log_file_success"
  ];
=======
  pythonImportsCheck = [ "pylink" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/square/pylink";
<<<<<<< HEAD
    changelog = "https://github.com/square/pylink/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dump_stack ];
=======
    changelog = "https://github.com/square/pylink/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.asl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
