{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, openblasCompat # build segfaults with regular openblas
, suitesparse
, glpk ? null
, gsl ? null
, fftw ? null
, withGlpk ? true
, withGsl ? true
, withFftw ? true
}:

buildPythonPackage rec {
  pname = "cvxopt";
  version = "1.2.3";

  disabled = isPyPy; # hangs at [translation:info]

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea62a2a1b8e2db3a6ae44ac394f58e4620149af226c250c6f2b18739b48cfc21";
  };

  # similar to Gsl, glpk, fftw there is also a dsdp interface
  # but dsdp is not yet packaged in nixpkgs
  preConfigure = ''
    export CVXOPT_BLAS_LIB_DIR=${openblasCompat}/lib
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
    export CVXOPT_SUITESPARSE_LIB_DIR=${suitesparse}/lib
    export CVXOPT_SUITESPARSE_INC_DIR=${suitesparse}/include
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
    homepage = http://cvxopt.org/;
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
    broken = stdenv.targetPlatform.isDarwin;
    license = licenses.gpl3Plus;
  };
}
