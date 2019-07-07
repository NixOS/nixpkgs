{ stdenv
, fetchPypi
, python
, buildPythonPackage
, isPy27
, isPy33
, isPy3k
, numpy
, llvmlite
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.44.0";
  pname = "numba";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56421bfc62f3c7c996ff11d5db7fc410909564e41b55379a82b9188fa4aa22f9";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite] ++ stdenv.lib.optional (!isPy3k) funcsigs ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

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
