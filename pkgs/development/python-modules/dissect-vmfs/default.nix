{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-vmfs";
<<<<<<< HEAD
  version = "3.6";
=======
  version = "3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.vmfs";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-FDxB87TeAMUp0hP9YS/nrqNx71+ZlHf3Bsaqvuwx36U=";
=======
    hash = "sha256-zLQzUSJnm5DOhKKCEWX1kVEmJK0oBGKHaWucVn1HOjg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.vmfs"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the VMFS file system";
    homepage = "https://github.com/fox-it/dissect.vmfs";
    changelog = "https://github.com/fox-it/dissect.vmfs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
