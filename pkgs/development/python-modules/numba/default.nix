{ lib
, stdenv
, pythonAtLeast
, pythonOlder
, fetchPypi
, python
, buildPythonPackage
, numpy
, llvmlite
, setuptools
, libcxx
}:

buildPythonPackage rec {
  version = "0.52.0";
  pname = "numba";
  # uses f-strings, python 3.9 is not yet supported
  disabled = pythonOlder "3.6" || pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44661c5bd85e3d3619be0a40eedee34e397e9ccb3d4c458b70e10bf95d1ce933";
  };

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [ numpy llvmlite setuptools ];
  pythonImportsCheck = [ "numba" ];
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
