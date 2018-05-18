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
  version = "0.22.0";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0a875f3d502f41f4a24444aa98fbf076a6bf36e2a0b3b4481b22e1c4a3acdc2";
  };

  propagatedBuildInputs = [ llvm ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

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
