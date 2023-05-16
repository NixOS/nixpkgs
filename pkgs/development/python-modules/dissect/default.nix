{ lib
, buildPythonPackage
, dissect-cim
, dissect-clfs
<<<<<<< HEAD
, dissect-cobaltstrike
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dissect-cstruct
, dissect-esedb
, dissect-etl
, dissect-eventlog
, dissect-evidence
, dissect-extfs
, dissect-fat
, dissect-ffs
, dissect-executable
, dissect-hypervisor
, dissect-ntfs
, dissect-ole
, dissect-regf
, dissect-shellitem
, dissect-sql
, dissect-squashfs
, dissect-target
, dissect-util
, dissect-vmfs
, dissect-volume
, dissect-xfs
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect";
<<<<<<< HEAD
  version = "3.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8.1";
=======
  version = "3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-WbKzmLeGsvzFA/bTTCqBEj/unbnzKQFzHFPRG411Cos=";
=======
    hash = "sha256-fprB+TPwtGpRcG6pkAWHsttjxTbFmmm96DguMh7f+18=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cim
    dissect-clfs
<<<<<<< HEAD
    dissect-cobaltstrike
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dissect-cstruct
    dissect-esedb
    dissect-etl
    dissect-eventlog
    dissect-evidence
    dissect-executable
    dissect-extfs
    dissect-fat
    dissect-ffs
    dissect-hypervisor
    dissect-ntfs
    dissect-ole
    dissect-regf
    dissect-shellitem
    dissect-sql
    dissect-squashfs
    dissect-target
    dissect-util
    dissect-vmfs
    dissect-volume
    dissect-xfs
  ] ++ dissect-target.optional-dependencies.full;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dissect"
  ];

  meta = with lib; {
    description = "Dissect meta module";
    homepage = "https://github.com/fox-it/dissect";
    changelog = "https://github.com/fox-it/dissect/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
