{ stdenv
, fetchPypi
, python
, buildPythonPackage
, isPy27
, isPy33
, isPy3k
, numpy
, llvmlite
, argparse
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.39.0";
  pname = "numba";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07749d1ddac8c4c0ce8b22bf3dec52ef2fd4922174c71447126807f5f8dc2bae";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite argparse] ++ stdenv.lib.optional (!isPy3k) funcsigs ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    ${python.interpreter} -m numba.runtests
  '';
  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  meta =  {
    homepage = http://numba.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
