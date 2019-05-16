{ lib, buildPythonPackage, fetchPypi, wheel, setuptools, packaging
, cmake, ninja, cython, codecov, coverage, six, virtualenv, pathpy
, pytest, pytestcov, pytest-virtualenv, pytest-mock, pytestrunner
, requests, flake8 }:

buildPythonPackage rec {
  pname = "scikit-build";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hh275lj98wgwi53mr9fqk8wh1dajjksch52xjax6a79gld4391a";
  };

  # Fixes incorrect specified requirement (part of next release)
  patches = [ ./fix_pytestrunner_req.patch ];

  propagatedBuildInputs = [ wheel setuptools packaging ];
  checkInputs = [ 
    cmake ninja cython codecov coverage six virtualenv pathpy
    pytest pytestcov pytest-mock pytest-virtualenv pytestrunner
    requests flake8
  ];

  disabledTests = lib.concatMapStringsSep " and " (s: "not " + s) ([
    "test_hello_develop" # tries setuptools develop install
    "test_wheel" # pip has no way to install missing dependencies
    "test_fortran_compiler" # passes if gfortran is available
    "test_install_command" # tries to alter out path
    "test_test_command" # tries to alter out path
  ]);

  checkPhase = ''
    py.test -k '${disabledTests}'
  '';

  meta = with lib; {
    homepage = http://scikit-build.org/;
    description = "Improved build system generator for CPython C/C++/Fortran/Cython extensions";
    license = with licenses; [ mit bsd2 ]; # BSD due to reuses of PyNE code
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
