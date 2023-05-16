{ lib
, awkward
, buildPythonPackage
, dask
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hatch-vcs
, hatchling
, pyarrow
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "dask-awkward";
<<<<<<< HEAD
  version = "2023.8.1";
=======
  version = "2023.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dask-contrib";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-sSsd35Psf3VEydkNxtd9mSBzV23S7fRM/jhbC9T62kY=";
  };

  patches = [
    (fetchpatch {
      name = "dask-awkward-pyarrow13-test-fixes.patch";
      url = "https://github.com/dask-contrib/dask-awkward/commit/abe7f4504b4f926232e4d0dfa5c601d265773d85.patch";
      hash = "sha256-IYlKTV6YasuKIJutB4cCmHeglGWUwBcvFgx1MZw4hjU=";
    })
  ];

=======
    hash = "sha256-c3NnARost/406cALQDKmeUsl2kFSQHAswAEwgreFXPc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "awkward"
  ];

  nativeBuildInputs = [
    hatch-vcs
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    awkward
    dask
  ];

  checkInputs = [
    pytestCheckHook
    pyarrow
  ];

  pythonImportsCheck = [
    "dask_awkward"
  ];

  disabledTests = [
    # Tests require network access
    "test_remote_double"
    "test_remote_single"
  ];

  meta = with lib; {
    description = "Native Dask collection for awkward arrays, and the library to use it";
    homepage = "https://github.com/dask-contrib/dask-awkward";
    changelog = "https://github.com/dask-contrib/dask-awkward/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
