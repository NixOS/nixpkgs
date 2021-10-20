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
  version = "0.54.0";
  pname = "numba";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bad6bd98ab2e41c34aa9c80b8d9737e07d92a53df4f74d3ada1458b0b516ccff";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "1.21" "1.22"

    substituteInPlace numba/__init__.py \
      --replace "(1, 20)" "(1, 21)"
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  propagatedBuildInputs = [ numpy llvmlite setuptools ];

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    ${python.interpreter} -m numba.runtests
  '';

  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  pythonImportsCheck = [ "numba" ];

  meta =  with lib; {
    homepage = "https://numba.pydata.org/";
    license = licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with maintainers; [ fridh ];
  };
}
