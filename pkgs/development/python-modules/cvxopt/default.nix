{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, blas, lapack # build segfaults with 64-bit blas
, suitesparse
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
  version = "1.2.4";

  disabled = isPyPy; # hangs at [translation:info]

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h9g79gxpgpy6xciqyypihw5q4ngp322lpkka1nkwk0ysybfsp7s";
  };

  buildInputs = [ blas lapack ];

  # similar to Gsl, glpk, fftw there is also a dsdp interface
  # but dsdp is not yet packaged in nixpkgs
  preConfigure = ''
    export CVXOPT_BLAS_LIB=blas
    export CVXOPT_LAPACK_LIB=lapack
    export CVXOPT_SUITESPARSE_LIB_DIR=${lib.getLib suitesparse}/lib
    export CVXOPT_SUITESPARSE_INC_DIR=${lib.getDev suitesparse}/include
  '' + lib.optionalString withGsl ''
    export CVXOPT_BUILD_GSL=1
    export CVXOPT_GSL_LIB_DIR=${gsl}/lib
    export CVXOPT_GSL_INC_DIR=${gsl}/include
  '' + lib.optionalString withGlpk ''
    export CVXOPT_BUILD_GLPK=1
    export CVXOPT_GLPK_LIB_DIR=${glpk}/lib
    export CVXOPT_GLPK_INC_DIR=${glpk}/include
  '' + lib.optionalString withFftw ''
    export CVXOPT_BUILD_FFTW=1
    export CVXOPT_FFTW_LIB_DIR=${fftw}/lib
    export CVXOPT_FFTW_INC_DIR=${fftw.dev}/include
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

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
