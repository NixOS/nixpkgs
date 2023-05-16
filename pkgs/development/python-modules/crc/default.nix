{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "crc";
<<<<<<< HEAD
  version = "4.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

=======
  version = "4.2.0";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-rH/jc6/gxww3NSCYrhu+InZX1HTTdJFfa52ioU8AclY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "crc"
  ];

  disabledTestPaths = [
    "test/bench"
  ];
=======
    hash = "sha256-h/RVMIJX+Lyted0FHNBcKY54EiirSclkBXCpAQSATq8=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "crc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "test/bench" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    changelog = "https://github.com/Nicoretti/crc/releases/tag/${version}";
    description = "Python module for calculating and verifying predefined & custom CRC's";
    homepage = "https://nicoretti.github.io/crc/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jleightcap ];
  };
}
