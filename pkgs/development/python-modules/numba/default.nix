{ stdenv
, pythonOlder
, fetchPypi
, python
, buildPythonPackage
, isPy27
, isPy3k
, numpy
, llvmlite
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.50.1";
  pname = "numba";
  # uses f-strings
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89e81b51b880f9b18c82b7095beaccc6856fcf84ba29c4f0ced42e4e5748a3a7";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite]
    ++ stdenv.lib.optionals isPy27 [ funcsigs singledispatch];

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    ${python.interpreter} -m numba.runtests
  '';
  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  meta =  {
    homepage = "http://numba.pydata.org/";
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
