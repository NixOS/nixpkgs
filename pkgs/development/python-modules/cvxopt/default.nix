{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, openblas
, blas
, lapack # build segfaults with 64-bit blas
, suitesparse
, unittestCheckHook
, glpk ? null
, gsl ? null
, fftw ? null
, withGlpk ? true
, withGsl ? true
, withFftw ? true
}:

assert (!blas.isILP64) && (!lapack.isILP64);

buildPythonPackage rec {
  pname = "cvxopt";
  version = "1.3.0";

  disabled = isPyPy; # hangs at [translation:info]

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ALGyMvnR+QLVeKnXWBS2f6AgdY1a5CLijKjO9iafpcY=";
  };

  buildInputs = (if stdenv.isDarwin then [ openblas ] else [ blas lapack ]);
  doCheck = !stdenv.isDarwin;

  # similar to Gsl, glpk, fftw there is also a dsdp interface
  # but dsdp is not yet packaged in nixpkgs
  preConfigure = (if stdenv.isDarwin then
  ''
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
  ''
  else
  ''
    export CVXOPT_BLAS_LIB=blas
    export CVXOPT_LAPACK_LIB=lapack
  '') +
  ''
    export CVXOPT_BUILD_DSDP=0
    export CVXOPT_SUITESPARSE_LIB_DIR=${lib.getLib suitesparse}/lib
    export CVXOPT_SUITESPARSE_INC_DIR=${lib.getDev suitesparse}/include
  '' + lib.optionalString withGsl ''
    export CVXOPT_BUILD_GSL=1
    export CVXOPT_GSL_LIB_DIR=${lib.getLib gsl}/lib
    export CVXOPT_GSL_INC_DIR=${lib.getDev gsl}/include
  '' + lib.optionalString withGlpk ''
    export CVXOPT_BUILD_GLPK=1
    export CVXOPT_GLPK_LIB_DIR=${lib.getLib glpk}/lib
    export CVXOPT_GLPK_INC_DIR=${lib.getDev glpk}/include
  '' + lib.optionalString withFftw ''
    export CVXOPT_BUILD_FFTW=1
    export CVXOPT_FFTW_LIB_DIR=${lib.getLib fftw}/lib
    export CVXOPT_FFTW_INC_DIR=${lib.getDev fftw}/include
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  meta = with lib; {
    homepage = "http://cvxopt.org/";
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
