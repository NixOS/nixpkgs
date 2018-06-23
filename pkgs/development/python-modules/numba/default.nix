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
  version = "0.38.1";
  pname = "numba";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48fb76b8dcde868d6426c7c7836b76a0b2b20861547770c27b6307f712c09bc5";
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
