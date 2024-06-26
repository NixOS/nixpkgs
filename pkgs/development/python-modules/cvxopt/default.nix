{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  python,
  blas,
  lapack,
  suitesparse,
  unittestCheckHook,
  glpk ? null,
  gsl ? null,
  fftw ? null,
  withGlpk ? true,
  withGsl ? true,
  withFftw ? true,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

buildPythonPackage rec {
  pname = "cvxopt";
  version = "1.3.2";
  format = "setuptools";

  disabled = isPyPy; # hangs at [translation:info]

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NGH6QsGyJAuk2h2YXKc1A5FBV/xMd0FzJ+1tfYWs2+Y=";
  };

  buildInputs = [
    blas
    lapack
  ];

  # similar to Gsl, glpk, fftw there is also a dsdp interface
  # but dsdp is not yet packaged in nixpkgs
  env =
    {
      CVXOPT_BLAS_LIB = "blas";
      CVXOPT_LAPACK_LIB = "lapack";
      CVXOPT_BUILD_DSDP = "0";
      CVXOPT_SUITESPARSE_LIB_DIR = "${lib.getLib suitesparse}/lib";
      CVXOPT_SUITESPARSE_INC_DIR = "${lib.getDev suitesparse}/include";
    }
    // lib.optionalAttrs withGsl {
      CVXOPT_BUILD_GSL = "1";
      CVXOPT_GSL_LIB_DIR = "${lib.getLib gsl}/lib";
      CVXOPT_GSL_INC_DIR = "${lib.getDev gsl}/include";
    }
    // lib.optionalAttrs withGlpk {
      CVXOPT_BUILD_GLPK = "1";
      CVXOPT_GLPK_LIB_DIR = "${lib.getLib glpk}/lib";
      CVXOPT_GLPK_INC_DIR = "${lib.getDev glpk}/include";
    }
    // lib.optionalAttrs withFftw {
      CVXOPT_BUILD_FFTW = "1";
      CVXOPT_FFTW_LIB_DIR = "${lib.getLib fftw}/lib";
      CVXOPT_FFTW_INC_DIR = "${lib.getDev fftw}/include";
    };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = with lib; {
    homepage = "https://cvxopt.org/";
    description = "Python Software for Convex Optimization";
    longDescription = ''
      CVXOPT is a free software package for convex optimization based on the
      Python programming language. It can be used with the interactive
      Python interpreter, on the command line by executing Python scripts,
      or integrated in other software via Python extension modules. Its main
      purpose is to make the development of software for convex optimization
      applications straightforward by building on Python's extensive
      standard library and on the strengths of Python as a high-level
      programming language.
    '';
    maintainers = with maintainers; [ edwtjo ];
    license = licenses.gpl3Plus;
  };
}
