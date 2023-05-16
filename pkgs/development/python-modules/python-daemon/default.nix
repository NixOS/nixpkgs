{ lib
, buildPythonPackage
, fetchPypi
, docutils
, lockfile
, pytestCheckHook
, testscenarios
, testtools
, twine
, python
, pythonOlder
, fetchpatch
}:

buildPythonPackage rec {
  pname = "python-daemon";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-bFdFI3L36v9Ak0ocA60YJr9eeTVY6H/vSRMeZGS02uU=";
=======
    sha256 = "bda993f1623b1197699716d68d983bb580043cf2b8a66a01274d9b8297b0aeaf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    twine
  ];

  propagatedBuildInputs = [
    docutils
    lockfile
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testscenarios
    testtools
  ];

<<<<<<< HEAD
=======
  patches = [
    # Should be fixed in the next release
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/python-daemon/raw/rawhide/f/python-daemon-safe_hasattr.patch";
      hash = "sha256-p5epAlM/sdel01oZkSI1vahUZYX8r90WCJuvBnfMaus=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/python-daemon/raw/rawhide/f/tests-remove-duplicate-mocking.patch";
      hash = "sha256-5b/dFR3Z8xaPw8AZU95apDZd4ZfmMQhAmavWkVaJog8=";
    })
  ];

  disabledTestPaths = [
    # requires removed distutils.command
    "test_version.py"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTests = [
    "begin_with_TestCase"
    "changelog_TestCase"
    "ChangeLogEntry"
    "DaemonContext"
    "file_descriptor"
    "get_distribution_version_info_TestCase"
    "InvalidFormatError_TestCase"
    "make_year_range_TestCase"
    "ModuleExceptions_TestCase"
    "test_metaclass_not_called"
    "test_passes_specified_object"
    "test_returns_expected"
    "value_TestCase"
    "YearRange_TestCase"
  ];

  pythonImportsCheck = [
    "daemon"
    "daemon.daemon"
    "daemon.pidfile"
<<<<<<< HEAD
=======
    "daemon.runner"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Library to implement a well-behaved Unix daemon process";
    homepage = "https://pagure.io/python-daemon/";
    # See "Copying" section in https://pagure.io/python-daemon/blob/main/f/README
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = with maintainers; [ ];
  };
}
