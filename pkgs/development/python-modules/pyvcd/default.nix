{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, six
, pytestCheckHook
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pyvcd";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-Mb4/UBRBqbjF3HJmD/e5z++bQ7ISGiPZb1htKGMnApA=";
=======
    sha256 = "ec4d9198bd20f9e07d78f6558ff8bcd45b172ee332e7e8a4588727eeb6a362bc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = "https://github.com/SanDisk-Open-Source/pyvcd";
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sb0 emily ];
  };
}
