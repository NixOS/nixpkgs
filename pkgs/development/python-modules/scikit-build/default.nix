{ lib
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
, fetchPypi
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, distro
, packaging
, setuptools
, wheel
, tomli
  # Test Inputs
, cmake
, cython
, git
, path
, pytestCheckHook
, pytest-mock
, requests
=======
, fetchPypi
, distro
, packaging
, python
, setuptools
, setuptools-scm
, wheel
  # Test Inputs
, cmake
, cython
, flake8
, ninja
, path
, pytestCheckHook
, pytest-mock
, pytest-virtualenv
, requests
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, virtualenv
}:

buildPythonPackage rec {
  pname = "scikit-build";
<<<<<<< HEAD
  version = "0.17.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "scikit_build";
    inherit version;
    hash = "sha256-tRpRo2s3xCZQmUtQR5EvWbIuMhCyPjIfKHYR+e9uXJ0=";
=======
  version = "0.16.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qbnMdHm3HmyNQ0WW363gJSU6riOtsiqaLYWFD9Uc7P0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # This line in the filterwarnings section of the pytest configuration leads to this error:
  #  E   UserWarning: Distutils was imported before Setuptools, but importing Setuptools also replaces the `distutils` module in `sys.modules`. This may lead to undesirable behaviors or errors. To avoid these issues, avoid using distutils directly, ensure that setuptools is installed in the traditional way (e.g. not an editable install), and/or make sure that setuptools is always imported before distutils.
  postPatch = ''
    sed -i "/'error',/d" pyproject.toml
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    distro
    packaging
    setuptools
<<<<<<< HEAD
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
=======
    setuptools-scm
    wheel
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    cmake
    cython
<<<<<<< HEAD
    git
    pytestCheckHook
    pytest-mock
    requests
=======
    ninja
    path
    pytestCheckHook
    pytest-mock
    pytest-virtualenv
    requests
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    virtualenv
  ];

  dontUseCmakeConfigure = true;

  disabledTests = [
    "test_hello_develop" # tries setuptools develop install
    "test_source_distribution" # pip has no way to install missing dependencies
    "test_wheel" # pip has no way to install missing dependencies
    "test_fortran_compiler" # passes if gfortran is available
    "test_install_command" # tries to alter out path
    "test_test_command" # tries to alter out path
    "test_setup" # tries to install using distutils
    "test_pep518" # pip exits with code 1
    "test_dual_pep518" # pip exits with code 1
    "test_isolated_env_trigger_reconfigure" # Regex pattern 'exit skbuild saving cmake spec' does not match 'exit skbuild running make'.
    "test_hello_wheel" # [Errno 2] No such file or directory: '_skbuild/linux-x86_64-3.9/setuptools/bdist.linux-x86_64/wheel/helloModule.py'
    # sdist contents differ, contains additional setup.py
    "test_hello_sdist"
    "test_manifest_in_sdist"
    "test_sdist_with_symlinks"
<<<<<<< HEAD
  ];

  meta = with lib; {
    changelog = "https://github.com/scikit-build/scikit-build/blob/${version}/CHANGES.rst";
=======
    # distutils.errors.DistutilsArgError: no commands supplied
    "test_invalid_command"
    "test_manifest_in_sdist"
    "test_no_command"
  ];

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "https://github.com/scikit-build/scikit-build";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
