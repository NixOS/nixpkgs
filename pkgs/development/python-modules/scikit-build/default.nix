{ lib
, buildPythonPackage
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
, virtualenv
}:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.16.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KiDEreqzwq7BHXC86WkJlc/w5Tvq/jIae1MACayo5zE=";
  };

  # This line in the filterwarnings section of the pytest configuration leads to this error:
  #  E   UserWarning: Distutils was imported before Setuptools, but importing Setuptools also replaces the `distutils` module in `sys.modules`. This may lead to undesirable behaviors or errors. To avoid these issues, avoid using distutils directly, ensure that setuptools is installed in the traditional way (e.g. not an editable install), and/or make sure that setuptools is always imported before distutils.
  postPatch = ''
    sed -i "/'error',/d" pyproject.toml
  '';

  propagatedBuildInputs = [
    distro
    packaging
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    cmake
    cython
    ninja
    path
    pytestCheckHook
    pytest-mock
    pytest-virtualenv
    requests
    six
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
    # distutils.errors.DistutilsArgError: no commands supplied
    "test_invalid_command"
    "test_manifest_in_sdist"
    "test_no_command"
  ];

  meta = with lib; {
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "https://github.com/scikit-build/scikit-build";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
