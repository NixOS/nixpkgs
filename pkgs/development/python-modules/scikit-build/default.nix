{ lib
, buildPythonPackage
, fetchPypi
, distro
, packaging
, setuptools
, wheel
# Test Inputs
, cmake
, codecov
, coverage
, cython
, flake8
, ninja
, pathpy
, pytest
, pytest-cov
, pytest-mock
, pytest-runner
, pytest-virtualenv
, requests
, six
, virtualenv
}:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XRd0ousVmI4IHFgsJUq0qXUgluajTyNUEct5vWFmDDc=";
  };

  propagatedBuildInputs = [
    distro
    packaging
    setuptools
    wheel
  ];
  checkInputs = [
    cmake
    codecov
    coverage
    cython
    flake8
    ninja
    pathpy
    pytest
    pytest-cov
    pytest-mock
    pytest-runner
    pytest-virtualenv
    requests
    six
    virtualenv
  ];

  dontUseCmakeConfigure = true;

  disabledTests = lib.concatMapStringsSep " and " (s: "not " + s) ([
    "test_hello_develop" # tries setuptools develop install
    "test_source_distribution" # pip has no way to install missing dependencies
    "test_wheel" # pip has no way to install missing dependencies
    "test_fortran_compiler" # passes if gfortran is available
    "test_install_command" # tries to alter out path
    "test_test_command" # tries to alter out path
    "test_setup" # tries to install using distutils
    "test_pep518" # pip exits with code 1
    "test_dual_pep518" # pip exits with code 1
  ]);

  checkPhase = ''
    py.test -k '${disabledTests}'
  '';

  meta = with lib; {
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    homepage = "http://scikit-build.org/";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
