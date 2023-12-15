{ lib
, stdenv
, fetchFromGitHub
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
  # The main dependency of llvmlite is numba, which we currently package an
  # untagged version of it (for numpy>1.25 support). That numba version
  # requires at least this version of llvmlite (also not yet officially
  # released, but at least tagged).
  version = "0.41.0dev0";
  format = "setuptools";

  disabled = isPyPy || !isPy3k;

  src = fetchFromGitHub {
    owner = "numba";
    repo = "llvmlite";
    rev = "v${version}";
    hash = "sha256-fsH+rqouweNENU+YlWr7m0bC0YdreQLNp1n2rwrOiFw=";
  };

  nativeBuildInputs = [ llvm ];
  propagatedBuildInputs = lib.optional (pythonOlder "3.4") enum34;

  # Disable static linking
  # https://github.com/numba/llvmlite/issues/93
  postPatch = ''
    substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

    substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
  '';

  # Set directory containing llvm-config binary
  preConfigure = ''
    export LLVM_CONFIG=${llvm.dev}/bin/llvm-config
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
