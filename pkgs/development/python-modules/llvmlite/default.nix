{ stdenv
, fetchPypi
, buildPythonPackage
, python
, llvm
, pythonOlder
, isPyPy
, enum34
}:

buildPythonPackage rec {
  pname = "llvmlite";
  version = "0.30.0";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eaa398d4cafb76e2d8f30ca6ab875039a1023c91e7a690c6ddec20e58bb9a07";
  };

  nativeBuildInputs = [ llvm ];
  propagatedBuildInputs = [ ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

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
    homepage = http://llvmlite.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
