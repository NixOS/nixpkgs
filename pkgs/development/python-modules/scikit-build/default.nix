{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
, pytestcov
, pytest-mock
, pytestrunner
, pytest-virtualenv
, requests
, six
, virtualenv
}:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7342017cc82dd6178e3b19377389b8a8d1f8b429d9cdb315cfb1094e34a0f526";
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
    pytestcov
    pytest-mock
    pytestrunner
    pytest-virtualenv
    requests
    six
    virtualenv
  ];

  dontUseCmakeConfigure = true;

  # scikit-build PR #458. Remove in version > 0.10.0
  patches = [
    (fetchpatch {
      name = "python38-platform_linux_distribution-fix-458";
      url = "https://github.com/scikit-build/scikit-build/commit/faa7284e5bc4c72bc8744987acdf3297b5d2e7e4.patch";
      sha256 = "1hgl3cnkf266zaw534b64c88waxfz9721wha0m6j3hsnxk76ayjv";
    })
  ];

  disabledTests = lib.concatMapStringsSep " and " (s: "not " + s) ([
    "test_hello_develop" # tries setuptools develop install
    "test_source_distribution" # pip has no way to install missing dependencies
    "test_wheel" # pip has no way to install missing dependencies
    "test_fortran_compiler" # passes if gfortran is available
    "test_install_command" # tries to alter out path
    "test_test_command" # tries to alter out path
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
