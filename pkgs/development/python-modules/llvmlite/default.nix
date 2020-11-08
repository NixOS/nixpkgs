{ stdenv
, fetchPypi
, buildPythonPackage
, python
, llvm
, pythonOlder
, isPyPy
, enum34
, isPy3k
}:

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.34.0";

  disabled = isPyPy || !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f03ee0d19bca8f2fe922bb424a909d05c28411983b0c2bc58b020032a0d11f63";
  };

  nativeBuildInputs = [ llvm ];
  requiredPythonModules = [ ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

  # Disable static linking
  # https://github.com/numba/llvmlite/issues/93
  postPatch = ''
    substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

    substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
  '';
  # Set directory containing llvm-config binary
  preConfigure = ''
    export LLVM_CONFIG=${llvm}/bin/llvm-config
  '';
  checkPhase = ''
    ${python.executable} runtests.py
  '';

  __impureHostDeps = stdenv.lib.optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

  passthru.llvm = llvm;

  meta = {
    description = "A lightweight LLVM python binding for writing JIT compilers";
    homepage = "http://llvmlite.pydata.org/";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
