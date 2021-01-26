{ lib
, stdenv
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
  version = "0.51.2";
  pname = "numba";
  # uses f-strings
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16bd59572114adbf5f600ea383880d7b2071ae45477e84a24994e089ea390768";
  };

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite]
    ++ lib.optionals isPy27 [ funcsigs singledispatch];

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    ${python.interpreter} -m numba.runtests
  '';
  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  meta =  with lib; {
    homepage = "http://numba.pydata.org/";
    license = licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with maintainers; [ fridh ];
  };
}
