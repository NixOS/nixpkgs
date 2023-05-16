{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pycryptodome
, pytestCheckHook
, pythonOlder
, rich
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-hypervisor";
<<<<<<< HEAD
  version = "3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.hypervisor";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-PTF1PSFsjD9lYa3SLd7329+ZZuSC07tN1GqwOndo8Go=";
=======
    hash = "sha256-6oPLl18U0TtVCkLsNN8Q4hBLArfXWWRkZI4VrFKJd9Q=";
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

  passthru.optional-dependencies = {
    full = [
      pycryptodome
      rich
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.hypervisor"
  ];

  meta = with lib; {
    description = "Dissect module implementing parsers for various hypervisor disk, backup and configuration files";
    homepage = "https://github.com/fox-it/dissect.hypervisor";
    changelog = "https://github.com/fox-it/dissect.hypervisor/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
