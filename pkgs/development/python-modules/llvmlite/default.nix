{ lib
, stdenv
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
  version = "0.36.0";

  disabled = isPyPy || !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "765128fdf5f149ed0b889ffbe2b05eb1717f8e20a5c87fa2b4018fbcce0fcfc9";
  };

  nativeBuildInputs = [ llvm ];
  propagatedBuildInputs = [ ] ++ lib.optional (pythonOlder "3.4") enum34;

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

  __impureHostDeps = lib.optionals stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

  passthru.llvm = llvm;

  meta = with lib; {
    description = "A lightweight LLVM python binding for writing JIT compilers";
    homepage = "http://llvmlite.pydata.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
}
