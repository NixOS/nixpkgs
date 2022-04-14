{ lib
, buildPythonPackage
, fetchPypi
, distro
, packaging
, setuptools
, wheel
# Test Inputs
, cmake
, coverage
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
  version = "0.13.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XRd0ousVmI4IHFgsJUq0qXUgluajTyNUEct5vWFmDDc=";
  };

  postPatch = ''
    sed -i '/distutils.dir_util._path_created/d' tests/__init__.py
  '';

  propagatedBuildInputs = [
    distro
    packaging
    setuptools
    wheel
  ];

  checkInputs = [
    cmake
    cython
    flake8
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
  ];

  meta = with lib; {
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "http://scikit-build.org/";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
