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
  version = "0.51.0";
  pname = "numba";
  # uses f-strings
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da57ef00bc814bf54446fb3f8c0374557a7476e40279ceabefd9f12b05cc3c0c";
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
